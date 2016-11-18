# PaginateV2 is a plugin built for Jekyll 3 that generates pagiatation for posts, categories and tags. 
# It is based on https://github.com/jekyll/jekyll-paginate, the original Jekyll paginator which was omitted from the Jekyll 3 release onwards. This code is not officially supported on Jekyll versions < 3.0.
#
# This class expands on the older paginator and now supports categories and tags.
# Note: Categories and Tags are read from the config in individual posts and the file system organization rather than a separate category system in the yml
#
# Author: Sverrir Sigmundarson
# Site: https://sverrirs.com
# Distributed Under The MIT License (MIT) as described in the LICENSE file
#   - https://opensource.org/licenses/MIT

# TODO:
# From: https://github.com/jekyll/jekyll-paginate/issues/27
# X Have this work with any type of file endings (configurable in yml file), namely markdown files as well and custom html file names
# X Add locale which should also index pages, multi value supported (e.g. en_US, en_GB)
# X Multiple tags and categories allowed within a single pagination
# X Allow pagination through combination of categories and language (to support different language translations)
# X Custom sorting of posts
# X Compatibility (uses the paginator and defaults to all posts)
# - Consider the configuration syntax discussed in https://github.com/jekyll/jekyll-paginate/issues/27
# X Limit pagination page count

module Jekyll 
  
  module PaginateV2
     
    # The default configuration for the Paginator
    DEFAULT = {
      'enabled'      => false,
      'collection'   => 'posts',
      'per_page'     => 10,
      'permalink'    => '/page:num/', # Supports :num as customizable elements
      'title_suffix' => ' - page :num', # Supports :num as customizable elements
      'page_num'     => 1,
      'sort_reverse' => false,
      'sort_field'   => 'date',
      'limit'        => 0 # Limit how many content objects to paginate (default: 0, means all)
    }
    
    class PaginationV2 < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # This generator should be passive with regard to its execution
      priority :lowest
      
      # Generate paginated pages if necessary (Default entry point)
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)
        
        # Retrieve and merge the folate configuration from the site yml file
        default_config = DEFAULT.merge(site.config['pagination'] || {})
        
        # If disabled then simply quit
        if !default_config['enabled']
          Jekyll.logger.info "Pagination:","disabled in site.config."
          return
        end
        
        Jekyll.logger.debug "Pagination:","Starting"
        
        # By default if pagination is enabled we attempt to find all index.html pages in the site
        templates = self.discover_paginate_templates(site)
        if( templates.size.to_i <= 0 )
          Jekyll.logger.warn "Pagination:","is enabled, but I couldn't find " +
          "any index.html page to use as the pagination template. Skipping pagination."
          return
        end

        # Get all posts that will be generated (excluding hidden posts such as drafts)
        all_posts = site.site_payload['site']['posts'].reject { |post| post['hidden'] }

        # Create the necessary indexes for the posts
        all_categories = self.index_posts_by(all_posts, 'categories')
        all_categories['posts'] = all_posts; # Popuplate a category for all posts 
                                             # (this is a default and must not be used in the category system)
        all_tags = self.index_posts_by(all_posts, 'tags')
        all_locales = self.index_posts_by(all_posts, 'locale')
        
        # Now for each template page generate the paginator for it
        for template in templates
          
          # All pages that should be paginated need to include the pagination config element
          if template.data['pagination'].is_a?(Hash)
            template_config = default_config.merge(template.data['pagination'])
            
            # Only paginate the template if it is explicitly enabled
            # requiring this makes the logic simpler as I don't need to determine which index pages 
            # were generated automatically and which weren't
            if( template_config['enabled'] )
              Jekyll.logger.info "Pagination:","found template: "+template.path
              # Now construct the pagination data for this template page
              self.paginate(site, template, template_config, all_posts, all_tags, all_categories, all_locales)
            end
          end
        end #for
        
      end # function generate
      
      #
      # Rolls through the entire site and finds all index.html pages available
      #
      # site - The Site.
      #
      def discover_paginate_templates(site)
        candidates = []
        site.pages.select do |page|
          # If the page has the enabled config set, supports any type of file name html or md
          if page.data['pagination'].is_a?(Hash) && page.data['pagination']['enabled']
            candidates << page
          end
        end
        return candidates
      end # function discover_paginate_templates
     
      #
      # Create a hash index for all post based on a key in the post.data table
      #
      def index_posts_by(all_posts, index_key)
        return nil if all_posts.nil?
        return all_posts if index_key.nil?
        index = {}
        for post in all_posts
          next if post.data.nil?
          next if !post.data.has_key?(index_key)
          next if post.data[index_key].nil?
          next if post.data[index_key].size <= 0
          next if post.data[index_key].to_s.strip.length == 0
          
          # Only tags and categories come as premade arrays, locale does not, so convert any data
          # elements that are strings into arrays
          post_data = post.data[index_key]
          if post_data.is_a?(String)
            post_data = post_data.split(/;|,|\s/)
          end
          
          for key in post_data
            key = key.downcase.strip
            # If the key is a delimetered list of values 
            # (meaning the user didn't use an array but a string with commas)
            for k_split in key.split(/;|,/)
              k_split = k_split.downcase.strip #Clean whitespace and junk
              if !index.has_key?(k_split)
                index[k_split.to_s] = []
              end
              index[k_split.to_s] << post
            end
          end
        end
        return index
      end # function index_posts_by
      
      #
      # Creates an intersection (only returns common elements)
      # between multiple arrays
      #
      def intersect_arrays(first, *rest)
        return nil if first.nil?
        return nil if rest.nil?
        
        intersect = first
        rest.each do |item|
          return [] if item.nil?
          intersect = intersect & item
        end
        return intersect
      end #function intersect_arrays
      
      #
      # Filters posts based on a keyed source_posts hash of indexed posts and performs a intersection of 
      # the two sets. Returns only posts that are common between all collections 
      #
      def read_config_value_and_filter_posts(config, config_key, posts, source_posts)
        return nil if posts.nil?
        return nil if source_posts.nil? # If the source is empty then simply don't do anything
        return posts if config.nil?
        return posts if !config.has_key?(config_key)
        return posts if config[config_key].nil?
        
        # Get the filter values from the config (this is the cat/tag/locale values that should be filtered on)
        config_value = config[config_key]
        
        # If we're dealing with a delimitered string instead of an array then let's be forgiving
        if( config_value.is_a?(String))
          config_value = config_value.split(/;|,/)
        end
          
        # Now for all filter values for the config key, let's remove all items from the posts that
        # aren't common for all collections that the user wants to filter on
        for key in config_value
          key = key.downcase.strip
          posts = self.intersect_arrays(posts, source_posts[key])
        end
        
        # The fully filtered final post list
        return posts
      end #function read_config_value_and_filter_posts
      
      #
      # Sorting routine used for ordering posts by custom fields.
      # Handles Strings separately as we want a case-insenstive sorting
      #
      def _sort_posts(a, b)
        if a.is_a?(String)
          return a.downcase <=> b.downcase
        end
        
        # By default use the built in sorting for the data type
        return a <=> b
      end
      
      # Paginates the blog's posts. Renders the index.html file into paginated
      # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
      # site-wide data.
      #
      # site - The Site.
      # template - The index.html Page that requires pagination.
      # config - The configuration settings that should be used
      #
      def paginate(site, template, config, all_posts, all_tags, all_categories, all_locales)
        
        # By default paginate on all posts in the site
        using_posts = all_posts
        
        # Now start filtering out any posts that the user doesn't want included in the pagination
        using_posts = self.read_config_value_and_filter_posts(config, 'category', using_posts, all_categories)
        using_posts = self.read_config_value_and_filter_posts(config, 'tag', using_posts, all_tags)
        using_posts = self.read_config_value_and_filter_posts(config, 'locale', using_posts, all_locales)
        
        # Apply sorting to the posts if configured, any field for the post is available for sorting
        if config['sort_field']
          sort_field = config['sort_field'].to_s
          using_posts.sort!{ |a,b| self._sort_posts(a.data[sort_field], b.data[sort_field]) }
          
          if config['sort_reverse']
            using_posts.reverse!
          end
        end
               
        # Calculate the max number of pagination-pages based on the configured per page value
        total_pages = self.calculate_number_of_pages(using_posts, config['per_page'])
        
        # If a upper limit is set on the number of total pagination pages then impose that now
        if config['limit'] && config['limit'].to_i > 0 && config['limit'].to_i < total_pages
          total_pages = config['limit'].to_i
        end
        
        # Now for each pagination page create it and configure the ranges for the collection
        # This .pager member is a built in thing in Jekyll and defines the paginator implementation
        # Simpy override to use mine
        (1..total_pages).each do |cur_page_nr|
          pager = PaginatorV2.new( config, using_posts, cur_page_nr, total_pages, template )
          if( cur_page_nr > 1)
            newpage = Page.new( site, site.source, template.dir, template.name)
            newpage.pager = pager
            newpage.dir = PaginatorV2.paginate_path(template, cur_page_nr, config)
            if( config.has_key?('title_suffix'))
              if( !template.data['title'] )
                tmp_title = site.config['title']
              else
                tmp_title = template.data['title']
              end
               
              newpage.data['title'] = "#{tmp_title}#{PaginatorV2.format_page_number(config['title_suffix'], cur_page_nr)}"
            end
            site.pages << newpage
          else
            template.pager = pager
          end
        end
      end # function paginate
      
      # Calculate the number of pages.
      #
      # all_posts - The Array of all Posts.
      # per_page  - The Integer of entries per page.
      #
      # Returns the Integer number of pages.
      def calculate_number_of_pages(all_posts, per_page)
        (all_posts.size.to_f / per_page.to_i).ceil
      end
      
    end # class PaginationV2
    
    # Handles the preparation of all the posts based on the current page index
    class PaginatorV2
      attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
        :previous_page, :previous_page_path, :next_page, :next_page_path
      
      # Initialize a new Paginator.
      #
      # site     - the Jekyll::Site object
      # page_nr  - The Integer page number.
      # all_posts - The Array of all the site's Posts.
      # num_pages - The Integer number of pages or nil if you'd like the number
      #             of pages calculated.
      def initialize(config, posts, cur_page_nr, num_pages, template )
        @page = cur_page_nr
        @per_page = config['per_page'].to_i
        @total_pages = num_pages

        if @page > @total_pages
          raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
        end

        init = (@page - 1) * @per_page
        offset = (init + @per_page - 1) >= posts.size ? posts.size : (init + @per_page - 1)

        @total_posts = posts.size
        @posts = posts[init..offset]
        @previous_page = @page != 1 ? @page - 1 : nil
        @previous_page_path = PaginatorV2.paginate_path(template, @previous_page, config)
        @next_page = @page != @total_pages ? @page + 1 : nil
        @next_page_path = PaginatorV2.paginate_path(template, @next_page, config)
      end

      # Convert this Paginator's data to a Hash suitable for use by Liquid.
      #
      # Returns the Hash representation of this Paginator.
      def to_liquid
        {
          'per_page' => per_page,
          'posts' => posts,
          'total_posts' => total_posts,
          'total_pages' => total_pages,
          'page' => page,
          'previous_page' => previous_page,
          'previous_page_path' => previous_page_path,
          'next_page' => next_page,
          'next_page_path' => next_page_path
        }
      end
      
      # Static: Return the pagination path of the page
      #
      # site     - the Jekyll::Site object
      # cur_page_nr - the pagination page number
      # config - the current configuration in use
      #
      # Returns the pagination path as a string
      def self.paginate_path(template, cur_page_nr, config)
        return nil if cur_page_nr.nil?
        return template.url if cur_page_nr <= 1
        format = config['permalink']
        if format.include?(":num")
          format = PaginatorV2.format_page_number(format, cur_page_nr)
        else
          raise ArgumentError.new("Invalid pagination path: '#{format}'. It must include ':num'.")
        end
        self.ensure_leading_slash(format)
      end #function paginate_path
      
      # Static: returns a fully formatted string with the current page number if configured
      #
      def self.format_page_number(toFormat, cur_page_nr)
        return toFormat.sub(':num', cur_page_nr.to_s)
      end #function format_page_number
      
      # Static: Return a String version of the input which has a leading slash.
      #         If the input already has a forward slash in position zero, it will be
      #         returned unchanged.
      #
      # path - a String path
      #
      # Returns the path with a leading slash
      def self.ensure_leading_slash(path)
        path[0..0] == "/" ? path : "/#{path}"
      end

      # Static: Return a String version of the input without a leading slash.
      #
      # path - a String path
      #
      # Returns the input without the leading slash
      def self.remove_leading_slash(path)
        path[0..0] == "/" ? path[1..-1] : path
      end
      
    end # class PaginatorGen2
    
  end # module PaginateV2
  
end # module Jekyll