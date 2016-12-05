module Jekyll
  module PaginateV2::Generator

    #
    # The main model for the pagination, handles the orchestration of the pagination and calling all the necessary bits and bobs needed :)
    #
    class PaginationModel

      @debug = false # is debug output enabled?
      @logging_lambda = nil # The lambda to use for logging
      @page_create_lambda = nil # The lambda used to create pages and add them to the site
      @page_remove_lambda = nil # Lambda to remove a page from the site.pages collection
      @collection_by_name_lambda = nil # Lambda to get all documents/posts in a particular collection (by name)

      # ctor
      def initialize(logging_lambda, page_create_lambda, page_remove_lambda, collection_by_name_lambda)
        @logging_lambda = logging_lambda
        @page_create_lambda = page_create_lambda
        @page_remove_lambda = page_remove_lambda
        @collection_by_name_lambda = collection_by_name_lambda
      end


      def run(default_config, site_pages, site_title)
        # By default if pagination is enabled we attempt to find all index.html pages in the site
        templates = self.discover_paginate_templates(site_pages)
        if( templates.size.to_i <= 0 )
          @logging_lambda.call "Is enabled, but I couldn't find any pagination page. Skipping pagination. "+
          "Pages must have 'paginate: enabled: true' in their front-matter for pagination to work.", "warn"
          return
        end

        # Now for each template page generate the paginator for it
        for template in templates
          # All pages that should be paginated need to include the pagination config element
          if template.data['pagination'].is_a?(Hash)
            template_config = default_config.merge(template.data['pagination'])

            # Handling deprecation of configuration values
            self._fix_deprecated_config_features(template_config)

            @debug = template_config['debug'] # Is debugging enabled on the page level

            self._debug_print_config_info(template_config, template.path)
            
            # Only paginate the template if it is explicitly enabled
            # requiring this makes the logic simpler as I don't need to determine which index pages 
            # were generated automatically and which weren't
            if( template_config['enabled'] )
              if !@debug
                @logging_lambda.call "found page: "+template.path
              end

              # Request all documents in all collections that the user has requested 
              all_posts = self.get_docs_in_collections(template_config['collection'])

              # Create the necessary indexes for the posts
              all_categories = PaginationIndexer.index_posts_by(all_posts, 'categories')
              all_categories['posts'] = all_posts; # Populate a category for all posts (this is here for backward compatibility, do not use this as it will be decommissioned 2018-01-01) 
                                                  # (this is a default and must not be used in the category system)
              all_tags = PaginationIndexer.index_posts_by(all_posts, 'tags')
              all_locales = PaginationIndexer.index_posts_by(all_posts, 'locale')

              # TODO: NOTE!!! This whole request for posts and indexing results could be cached to improve performance, leaving like this for now during testing

              # Now construct the pagination data for this template page
              #self.paginate(site, template, template_config, all_posts, all_tags, all_categories, all_locales)
              self.paginate(template, template_config, site_title, all_posts, all_tags, all_categories, all_locales)
            end
          end
        end #for
      end # function run

      #
      # This function is here to retain the old compatability logic with the jekyll-paginate gem
      # no changes should be made to this function and it should be retired and deleted after 2018-01-01
      # (REMOVE AFTER 2018-01-01)
      #
      def run_compatability(legacy_config, site_pages, site_title, all_posts)

        # Decomissioning error
        if( date = Date.strptime("20180101","%Y%m%d") <= Date.today )
          raise ArgumentError.new("Legacy jekyll-paginate configuration compatibility mode has expired. Please upgrade to jekyll-paginate-v2 configuration.")
        end

        # Two month warning or general notification
        if( date = Date.strptime("20171101","%Y%m%d") <= Date.today )
          @logging_lambda.call "Legacy pagination logic will stop working on Jan 1st 2018, update your configs before that time.", "warn"
        else
          @logging_lambda.call "Detected legacy jekyll-paginate logic being run. "+
          "Please update your configs to use the new pagination logic. This compatibility function "+
          "will stop working after Jan 1st 2018 and your site build will throw an error."
        end

        if template = CompatibilityUtils.template_page(site_pages, legacy_config['legacy_source'], legacy_config['permalink'])
          CompatibilityUtils.paginate(legacy_config, all_posts, template, @page_create_lambda)
        else
          @logging_lambda.call "Legacy pagination is enabled, but I couldn't find " +
          "an index.html page to use as the pagination page. Skipping pagination.", "warn"
        end
      end # function run_compatability (REMOVE AFTER 2018-01-01)

      # Returns the combination of all documents in the collections that are specified
      # raw_collection_names can either be a list of collections separated by a ',' or ' ' or a single string
      def get_docs_in_collections(raw_collection_names)
        if raw_collection_names.is_a?(String)
          collection_names = raw_collection_names.split(/;|,|\s/)
        else
          collection_names = raw_collection_names
        end

        docs = []
        # Now for each of the collections get the docs
        for coll_name in collection_names
          # Request all the documents for the collection in question, and join it with the total collection 
          docs += @collection_by_name_lambda.call(coll_name.downcase.strip)
        end

        return docs
      end

      def _fix_deprecated_config_features(config)
        keys_to_delete = []

        # As of v1.5.1 the title_suffix is deprecated and 'title' should be used 
        # but only if title has not been defined already!
        if( !config['title_suffix'].nil? )
          if( config['title'].nil? )
            config['title'] = ":title" + config['title_suffix'].to_s # Migrate the old key to title
          end
          keys_to_delete << "title_suffix" # Always remove the depricated key if found
        end

        # Delete the depricated keys
        config.delete_if{ |k,| keys_to_delete.include? k }
      end

      def _debug_print_config_info(config, page_path)
        r = 20
        f = "Pagination: ".rjust(20)
        # Debug print the config
        if @debug
          puts f + "----------------------------"
          puts f + "Page: "+page_path.to_s
          puts f + " Active configuration"
          puts f + "  Enabled: ".ljust(r) + config['enabled'].to_s
          puts f + "  Items per page: ".ljust(r) + config['per_page'].to_s
          puts f + "  Permalink: ".ljust(r) + config['permalink'].to_s
          puts f + "  Title: ".ljust(r) + config['title'].to_s
          puts f + "  Limit: ".ljust(r) + config['limit'].to_s
          puts f + "  Sort by: ".ljust(r) + config['sort_field'].to_s
          puts f + "  Sort reverse: ".ljust(r) + config['sort_reverse'].to_s
          
          puts f + " Active Filters"
          puts f + "  Collection: ".ljust(r) + config['collection'].to_s
          puts f + "  Category: ".ljust(r) + (config['category'].nil? || config['category'] == "posts" ? "[Not set]" : config['category'].to_s)
          puts f + "  Tag: ".ljust(r) + (config['tag'].nil? ? "[Not set]" : config['tag'].to_s)
          puts f + "  Locale: ".ljust(r) + (config['locale'].nil? ? "[Not set]" : config['locale'].to_s)

          if config['legacy'] 
            puts f + " Legacy Paginate Code Enabled"
            puts f + "  Legacy Paginate: ".ljust(r) + config['per_page'].to_s
            puts f + "  Legacy Source: ".ljust(r) + config['legacy_source'].to_s
            puts f + "  Legacy Path: ".ljust(r) + config['paginate_path'].to_s
          end
        end
      end

      def _debug_print_filtering_info(filter_name, before_count, after_count)
        # Debug print the config
        if @debug
          puts "Pagination: ".rjust(20) + " Filtering by: "+filter_name.to_s.ljust(9) + " " + before_count.to_s.rjust(3) + " => " + after_count.to_s  
        end
      end
      
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
            
      # Paginates the blog's posts. Renders the index.html file into paginated
      # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
      # site-wide data.
      #
      # site - The Site.
      # template - The index.html Page that requires pagination.
      # config - The configuration settings that should be used
      #
      def paginate(template, config, site_title, all_posts, all_tags, all_categories, all_locales)
        # By default paginate on all posts in the site
        using_posts = all_posts
        
        # Now start filtering out any posts that the user doesn't want included in the pagination
        before = using_posts.size.to_i
        using_posts = PaginationIndexer.read_config_value_and_filter_posts(config, 'category', using_posts, all_categories)
        self._debug_print_filtering_info('Category', before, using_posts.size.to_i)
        before = using_posts.size.to_i
        using_posts = PaginationIndexer.read_config_value_and_filter_posts(config, 'tag', using_posts, all_tags)
        self._debug_print_filtering_info('Tag', before, using_posts.size.to_i)
        before = using_posts.size.to_i
        using_posts = PaginationIndexer.read_config_value_and_filter_posts(config, 'locale', using_posts, all_locales)
        self._debug_print_filtering_info('Locale', before, using_posts.size.to_i)
        
        # Apply sorting to the posts if configured, any field for the post is available for sorting
        if config['sort_field']
          sort_field = config['sort_field'].to_s
          using_posts.sort!{ |a,b| Utils.sort_values(Utils.sort_get_post_data(a.data, sort_field), Utils.sort_get_post_data(b.data, sort_field)) }
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
          pager = Paginator.new( config['per_page'], config['permalink'], using_posts, cur_page_nr, total_pages, template.url, template.path )
          
          # External Proc call to create the actual page for us (this is passed in when the pagination is run)
          newpage = @page_create_lambda.call( template.path )
          newpage.pager = pager

          # Force the newly created files to live under the same dir as the template plus the permalink structure
          new_path = Utils.paginate_path(template.url, template.path, cur_page_nr, config['permalink'])
          newpage.dir = new_path
          
          # Update the permalink for the paginated pages as well if the template had one
          if( template.data['permalink'] )
            newpage.data['permalink'] = new_path
          end

          # Transfer the title across to the new page
          if( !template.data['title'] )
            tmp_title = site_title
          else
            tmp_title = template.data['title']
          end
          # If the user specified a title suffix to be added then let's add that to all the pages except the first
          if( cur_page_nr > 1 && config.has_key?('title') )
            newpage.data['title'] = "#{Utils.format_page_title(Utils.format_page_number(config['title'], cur_page_nr), tmp_title)}"
          else
            newpage.data['title'] = tmp_title
          end


          # Signals that this page is automatically generated by the pagination logic
          # (we don't do this for the first page as it is there to mask the one we removed)
          if cur_page_nr > 1
            newpage.data['autogen'] = "jekyll-paginate-v2"
          end
          
          # Only request that the template page be removed from the output once
          # We actually create a dummy page for this actual page in the Jekyll output 
          # so we don't need the original page anymore
          if cur_page_nr == 1
            @page_remove_lambda.call( template )
          end
        end
      end # function paginate

    end # class PaginationV2

  end # module PaginateV2
end # module Jekyll