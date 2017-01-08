module Jekyll
  module PaginateV2::AutoPages

    ## TODO
    # 1. COME UP WITH A BETTER WAY TO DO FILTERING PER 'TAGS', INSTEAD OF UTILS.index_posts_by
    # 2. IMPLEMENT CATEGORIES
    # 3. IMPLEMENT COLLECTIONS
    # 4. DOCUMENT

    #
    # When the site has been read then go a head an generate the necessary extra pages
    # This code is adapted from Stephen Crosby's code https://github.com/stevecrozz
    Jekyll::Hooks.register :site, :post_read do |site|

      # Development in progress...
      return
      
      # Get the configuration for the auto pages
      autopage_config = Jekyll::Utils.deep_merge_hashes(DEFAULT, site.config['autopages'] || {})
      pagination_config = Jekyll::Utils.deep_merge_hashes(Jekyll::PaginateV2::Generator::DEFAULT, site.config['pagination'] || {})

      # If disabled then don't do anything
      if !autopage_config['enabled'] || autopage_config['enabled'].nil?
        Jekyll.logger.info "AutoPages:","Disabled/Not configured in site.config."
        next ## Break the loop, could be an issue if the hook is called again though??
      end

      # TODO: Should I detect here and disable if we're running the legacy paginate code???!

      # Simply gather all documents across all pages/posts/collections that we have
      # we could be generating quite a few empty pages but the logic is just vastly simpler than trying to 
      # figure out what tag/category belong to which collection.
      posts_to_use = Utils.collect_all_docs(site.collections)

      ###############################################
      # Generate the Tag pages if enabled
      if !autopage_config['tags'].nil?
        autopage_tag_config = autopage_config['tags']
        if autopage_tag_config ['enabled']
          Jekyll.logger.info "AutoPages:","Generating tag pages"

          # Roll through all documents in the posts collection and extract the tags
          tags_keys = Utils.index_posts_by(posts_to_use, 'tags').keys # Cannot use just the posts here, must use all things.. posts, collections...

          tags_keys.each do |tag|
            # Iterate over each layout specified in the config
            autopage_tag_config ['layouts'].each do | layout_name |
              #Jekyll.logger.info "AutoPages:","Tag '"+tag+"' > layout '"+layout_name+"'"
              # Use site.dest here as these pages are never created in the actual source but only inside the _site folder
              site.pages << TagAutoPage.new(site, site.dest, autopage_tag_config, pagination_config, layout_name, tag)
            end
          end
        else
          Jekyll.logger.info "AutoPages:","Tag pages are disabled/not configured in site.config."
        end
      end


      ###############################################
      # Generate the category pages if enabled
      #if !autopage_config['categories'].nil? 
      
      #end
      

      ###############################################
      # Generate the Collection pages if enabled
      #if !autopage_config['collections'].nil? 
      
      #end
    

      
    
    end # Jekyll::Hooks
  end # module PaginateV2
end # module Jekyll