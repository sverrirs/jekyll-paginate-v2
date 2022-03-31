module Jekyll
  module PaginateV2::AutoPages

    #
    # This function is called right after the main generator is triggered by Jekyll
    # This code is adapted from Stephen Crosby's code https://github.com/stevecrozz
    def self.create_autopages(site)
      # Get the configuration for the auto pages
      autopage_config = site.config['autopages'] || {}
      pagination_config = Jekyll::Utils.deep_merge_hashes(Jekyll::PaginateV2::Generator::DEFAULT, site.config['pagination'] || {})

      # Simply gather all documents across all pages/posts/collections that we have
      # and store them under each collection name
      coll_docs = Utils.collect_all_docs(site.collections)
      # we don't use the posts collection
      coll_docs.delete("posts")
      coll_names = coll_docs.keys

      # If disabled then don't do anything
      if !autopage_config['enabled'] || autopage_config['enabled'].nil?
        Jekyll.logger.info "AutoPages:","Disabled/Not configured in site.config."
        return
      end

      autopages_log(autopage_config, *coll_names)

      coll_docs.each do |coll_name, coll_data|
        createcolpage_lambda = lambda do |autopage_col_config, doc|
          site.pages << AutoPage.new(site, autopage_col_config, pagination_config, coll_name, doc)
        end

        autopage_create(autopage_config, coll_name, coll_data, createcolpage_lambda)
      end
    end # create_autopages

    # STATIC: this function actually performs the steps to generate the autopages. It uses a lambda function to delegate the creation of the individual
    #         page types to the calling code (this way all features can reuse the logic).
    #
    def self.autopage_create(autopage_config, configkey_name, coll_data, createpage_lambda)
      unless autopage_config[configkey_name].nil?
        ap_sub_config = autopage_config[configkey_name]
        if ap_sub_config['enabled']
          coll_data.each do |doc|
              createpage_lambda.call(ap_sub_config, doc)
          end
        end
      end
    end

    def self.autopages_log(config, *config_keys)
      enabled, disabled = [], []
      config_keys.each do |key|
        key_config = config[key] # config for key
        next if config.nil? || key_config['silent']

        (key_config['enabled'] ? enabled : disabled) << key
      end

      Jekyll.logger.info("AutoPages:","Generating pages for #{_to_sentence(enabled)}") unless enabled.empty?
      Jekyll.logger.info("AutoPages:","#{_to_sentence(disabled)} pages are disabled/not configured in site.config") unless disabled.empty?
    end

    def self._to_sentence(array)
      if array.empty?
        ""
      elsif array.length == 1
        array[0].to_s
      else
        array[0..-2].join(", ") + " & " + array.last
      end
    end
  end # module PaginateV2
end # module Jekyll
