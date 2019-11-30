module Jekyll
  module PaginateV2::Generator

    # 
    # Performs indexing of the posts or collection documents
    # as well as filtering said collections when requested by the defined filters.
    class PaginationIndexer
      #
      # Create a hash index for all post based on a key in the post.data table
      #
      def self.index_posts_by(all_posts, index_key)
        return nil if all_posts.nil?
        return all_posts if index_key.nil?
        index = {}
        all_posts.each do |post|
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
          
          post_data.each do |key|
            key = key.to_s.downcase.strip
            # If the key is a delimetered list of values 
            # (meaning the user didn't use an array but a string with commas)
            key.split(/;|,/).each do |k_split|            
              k_split = k_split.to_s.downcase.strip #Clean whitespace and junk
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
      def self.intersect_arrays(first, *rest)
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
      def self.read_config_value_and_filter_posts(config, config_key, posts, source_posts, page_language = nil)
        return nil if posts.nil?
        return nil if source_posts.nil? # If the source is empty then simply don't do anything
        return posts if config.nil?

        plural_key = Utils.plural(config_key)

        # Jekyll.logger.info "Pag-debug: ", "Key: " + config_key + " => " + config[config_key]
          
        return posts if !config.has_key?(config_key) && !config.has_key?(plural_key)
        return posts if config[config_key].nil? && config[plural_key].nil?
        
        lang = "en" # Default_lang
        unless page_language.nil?
            lang = page_language.to_s
        end
          
        # Replace "locale: :language" by lang
        if config_key == "locale"
            config[config_key] = lang
        end
          
        if config.include?("permalink") and !config["permalink"].nil?
            config["permalink"] = config["permalink"].sub(":language", lang)  
        end
        
        # Get the filter values from the config (this is the cat/tag/locale values that should be filtered on)
        
        if config[config_key].is_a?(Hash) || config[plural_key].is_a?(Hash)
          # { values: [..], matching: any|all }
          config_hash = config[config_key].is_a?(Hash) ? config[config_key] : config[plural_key]
          config_value = Utils.config_values(config_hash, 'value')
          matching = config_hash['matching'] || 'all'
        else
          # Default array syntax
          config_value = Utils.config_values(config, config_key)
          matching = 'all'
        end
          
        matching = matching.to_s.downcase.strip

        # Filter on any/all specified categories, etc.

        if matching == "all"
          # Now for all filter values for the config key, let's remove all items from the posts that
          # aren't common for all collections that the user wants to filter on
          config_value.each do |key|
            key = key.to_s.downcase.strip
            posts = PaginationIndexer.intersect_arrays(posts, source_posts[key])
          end

        elsif matching == "any"
          # "or" filter: Remove posts that don't have at least one required key
          posts.delete_if { |post|
            post_config = Utils.config_values(post.data, config_key)
            (config_value & post_config).empty?
          }

        # else no filter
        end

        # The fully filtered final post list
        return posts
      end #function read_config_value_and_filter_posts
    end #class PaginationIndexer

  end #module PaginateV2
end #module Jekyll
