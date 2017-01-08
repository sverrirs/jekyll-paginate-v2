module Jekyll
  module PaginateV2::AutoPages

    class Utils

      # Static: returns a fully formatted string with the tag macro (:tag) replaced
      #
      def self.format_tag_macro(toFormat, tag)
        return toFormat.sub(':tag', Jekyll::Utils.slugify(tag.to_s))
      end #function format_tag_macro

      # Static: returns a fully formatted string with the category macro (:cat) replaced
      #
      def self.format_cat_macro(toFormat, category)
        return toFormat.sub(':cat', Jekyll::Utils.slugify(category.to_s))
      end #function format_cat_macro

      # Static: returns a fully formatted string with the collection macro (:coll) replaced
      #
      def self.format_coll_macro(toFormat, collection)
        return toFormat.sub(':coll', Jekyll::Utils.slugify(collection.to_s))
      end #function format_coll_macro

      # Static: returns all documents from all collections defined in the hash of collections passed in
      # excludes all pagination pages though
      def self.collect_all_docs(site_collections)
        coll = []
        for coll_name, coll_data in site_collections
          if !coll_data.nil? 
            coll += coll_data.docs.select { |doc| !doc.data.has_key?('pagination') }.each{ |doc| doc.data['__coll'] = coll_name } # Exclude all pagination pages and then for every page store it's collection name
          end
        end
        return coll
      end

      def self.index_posts_by(all_posts, index_key)
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

    end # class Utils

  end # module PaginateV2
end # module Jekyll