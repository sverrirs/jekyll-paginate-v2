module Jekyll
  module PaginateV2
  
    #
    # The main entry point into the generator, called by Jekyll
    # this function extracts all the necessary information from the jekyll end and passes it into the pagination 
    # logic. Additionally it also contains all site specific actions that the pagination logic needs access to
    # (such as how to create new pages)
    # 
    class PaginationGenerator < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # This generator should be passive with regard to its execution
      priority :lowest
      
      # Generate paginated pages if necessary (Default entry point)
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)

        # Retrieve and merge the pagination configuration from the site yml file
        default_config = DEFAULT.merge(site.config['pagination'] || {})

        # Compatibility Note: (REMOVE AFTER 2018-01-01)
        # If the legacy paginate logic is configured then read those values and merge with config
        if !site.config['paginate'].nil?
          # You cannot run both the new code and the old code side by side
          if !site.config['pagination'].nil?
            err_msg = "The new jekyll-paginate-v2 and the old jekyll-paginate logic cannot both be configured in the site config at the same time. Please disable the old 'paginate:' config settings."
            Jekyll.logger.error err_msg 
            raise ArgumentError.new(err_msg)
          end

          default_config['per_page'] = site.config['paginate'].to_i
          default_config['legacy_source'] = site.config['source']
          if !site.config['paginate_path'].nil?
            default_config['permalink'] = site.config['paginate_path'].to_s
          end
          # In case of legacy, enable pagination by default
          default_config['enabled'] = true
          default_config['legacy'] = true
        end # Compatibility END (REMOVE AFTER 2018-01-01)

        # If disabled then simply quit
        if !default_config['enabled']
          Jekyll.logger.info "Pagination:","Disabled in site.config."
          return
        end
        
        Jekyll.logger.debug "Pagination:","Starting"

        ################# 1 ###################
        # Extract the necessary information out of the site object and then instantiate the model

        # Get all posts that will be generated (excluding hidden posts that have hidden:true in the front matter)
        all_posts = site.site_payload['site']['posts'].reject { |post| post['hidden'] }

        # Get all pages in the site (this will be used to find the pagination templates)
        all_pages = site.pages

        # Get the default title of the site (used as backup when there is no title available for pagination)
        site_title = site.config['title']

        ################ 2 ####################
        # Create the proc that constructs the real-life site page
        # This is necessary to decouple the code from the Jekyll site object
        page_create_lambda = lambda do | template_dir, template_name |
          # Create the new page
          newpage = Page.new( site, site.source, template_dir, template_name)
          # Add the page to the site so that it is generated correctly
          site.pages << newpage
          # Return the site to the calling code
          return newpage
        end

        ################ 3 ####################
        # Create a proc that will delegate logging
        # Decoupling Jekyll specific logging
        logging_lambda = lambda do | message, type="info" |
          if type == 'debug'
            Jekyll.logger.debug "Pagination:", message
          elsif type == 'error'
            Jekyll.logger.error "Pagination:", message
          elsif type == 'warn'
            Jekyll.logger.warn "Pagination:", message
          else
            Jekyll.logger.info "Pagination:", message
          end
        end

        ################ 4 ####################
        # Now create and call the model with the real-life page creation proc and site data
        model = PaginationModel.new()
        if( default_config['legacy'] ) #(REMOVE AFTER 2018-01-01)
          model.run_compatability(default_config, all_pages, site_title, all_posts, page_create_lambda, logging_lambda) #(REMOVE AFTER 2018-01-01)
        else
          model.run(default_config, all_pages, site_title, all_posts, page_create_lambda, logging_lambda)
        end

      end
    end # class PaginationGenerator

  end # module PaginateV2
end # module Jekyll