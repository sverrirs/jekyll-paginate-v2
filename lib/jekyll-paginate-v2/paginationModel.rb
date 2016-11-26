module Jekyll
  module PaginateV2

    class PaginationModel

      def run(default_config, site_pages, site_title, all_posts, page_create_lambda, logging_lambda)
        # By default if pagination is enabled we attempt to find all index.html pages in the site
        templates = self.discover_paginate_templates(site_pages)
        if( templates.size.to_i <= 0 )
          logging_lambda.call "Is enabled, but I couldn't find any pagination page. Skipping pagination. "+
          "Pages must have 'paginate: enabled: true' in their front-matter for pagination to work.", "warn"
          return
        end

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
              logging_lambda.call "found page: "+template.path
              # Now construct the pagination data for this template page
              #self.paginate(site, template, template_config, all_posts, all_tags, all_categories, all_locales)
              self.paginate(template, template_config, site_title, all_posts, all_tags, all_categories, all_locales, page_create_lambda, logging_lambda)
            end
          end
        end #for
      end # function run

      #
      # This function is here to retain the old compatability logic with the jekyll-paginate gem
      # no changes should be made to this function and it should be retired and deleted after 2018-01-01
      # (REMOVE AFTER 2018-01-01)
      #
      def run_compatability(legacy_config, site_pages, site_title, all_posts, page_create_lambda, logging_lambda)

        # Decomissioning error
        if( date = Date.strptime("20180101","%Y%m%d") <= Date.today )
          raise ArgumentError.new("Legacy jekyll-paginate configuration compatibility mode has expired. Please upgrade to jekyll-paginate-v2 configuration.")
        end

        # Two month warning or general notification
        if( date = Date.strptime("20171101","%Y%m%d") <= Date.today )
          logging_lambda.call "Legacy pagination logic will stop working on Jan 1st 2018, update your configs before that time.", "warn"
        else
          logging_lambda.call "Detected legacy jekyll-paginate logic being run. "+
          "Please update your configs to use the new pagination logic. This compatibility function "+
          "will stop working after Jan 1st 2018 and your site build will throw an error."
        end

        if template = CompatibilityUtils.template_page(site_pages, legacy_config['legacy_source'], legacy_config['permalink'])
          CompatibilityUtils.paginate(legacy_config, all_posts, template, page_create_lambda, logging_lambda)
        else
          logging_lambda.call "Legacy pagination is enabled, but I couldn't find " +
          "an index.html page to use as the pagination page. Skipping pagination.", "warn"
        end
      end # function run_compatability (REMOVE AFTER 2018-01-01)
      
      #
      # Rolls through all the pages passed in and finds all pages that have pagination enabled on them.
      # These pages will be used as templates
      #
      # site_pages - All pages in the site
      #
      def discover_paginate_templates(site_pages)
        candidates = []
        site_pages.select do |page|
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
      def paginate(template, config, site_title, all_posts, all_tags, all_categories, all_locales, page_create_lambda, logging_lambda)
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
        total_pages = Utils.calculate_number_of_pages(using_posts, config['per_page'])
        
        # If a upper limit is set on the number of total pagination pages then impose that now
        if config['limit'] && config['limit'].to_i > 0 && config['limit'].to_i < total_pages
          total_pages = config['limit'].to_i
        end
        
        # Now for each pagination page create it and configure the ranges for the collection
        # This .pager member is a built in thing in Jekyll and defines the paginator implementation
        # Simpy override to use mine
        (1..total_pages).each do |cur_page_nr|
          pager = Paginator.new( config['per_page'], config['permalink'], using_posts, cur_page_nr, total_pages, template.url )
          if( cur_page_nr > 1)
            # External Proc call to create the actual page for us (this is passed in when the pagination is run)
            newpage = page_create_lambda.call( template.dir, template.name )
            newpage.pager = pager
            newpage.dir = Utils.paginate_path(template.url, cur_page_nr, config['permalink'])
            if( config.has_key?('title_suffix'))
              if( !template.data['title'] )
                tmp_title = site_title
              else
                tmp_title = template.data['title']
              end
               
              newpage.data['title'] = "#{tmp_title}#{Utils.format_page_number(config['title_suffix'], cur_page_nr)}"
            end
          else
            template.pager = pager
          end
        end
      end # function paginate

    end # class PaginationV2

  end # module PaginateV2
end # module Jekyll