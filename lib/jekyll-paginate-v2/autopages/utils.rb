module Jekyll
  module PaginateV2::AutoPages

    class Utils

      # Static: Expand placeholders within s
      def self.expand_placeholders(s, placeholders)
        # Create a pattern like /abc|def|./ for each key in placeholders
        # Longer keys come first to ensure that a key like :foobar will take priority over :foo.
        pattern = Regexp.new(((placeholders.keys.sort { |a, b| b.length <=> a.length }) + ["."]).join("|"))

        # Format the output string. The pattern will cause scan() to return an array where each
        # element is a single placeholder key, or a single character.
        return s.scan(pattern).map { |token| placeholders.key?(token) ? placeholders[token] : token }.join
      end

      # Static: returns a fully formatted string with the tag macro (:tag) and tag name macro
      # (:tag_name) replaced
      #
      def self.format_tag_macro(toFormat, tag, tag_name, slugify_config=nil)
        slugify_mode = slugify_config.has_key?('mode') ? slugify_config['mode'] : nil
        slugify_cased = slugify_config.has_key?('cased') ? slugify_config['cased'] : false

        return expand_placeholders(toFormat, {
          ":tag"      => Jekyll::Utils.slugify(tag.to_s, mode:slugify_mode, cased:slugify_cased),
          ":tag_name" => tag_name,
        })
      end #function format_tag_macro

      # Static: returns a fully formatted string with the category macro (:cat) and category
      # name macro (:cat_name) replaced
      #
      def self.format_cat_macro(toFormat, category, category_name, slugify_config=nil)
        slugify_mode = slugify_config.has_key?('mode') ? slugify_config['mode'] : nil
        slugify_cased = slugify_config.has_key?('cased') ? slugify_config['cased'] : false

        return expand_placeholders(toFormat, {
          ":cat"      => Jekyll::Utils.slugify(category.to_s, mode:slugify_mode, cased:slugify_cased),
          ":cat_name" => category_name,
        })
      end #function format_cat_macro

      # Static: returns a fully formatted string with the collection macro (:coll) replaced
      #
      def self.format_coll_macro(toFormat, collection, collection_name, slugify_config=nil)
        slugify_mode = slugify_config.has_key?('mode') ? slugify_config['mode'] : nil
        slugify_cased = slugify_config.has_key?('cased') ? slugify_config['cased'] : false

        return expand_placeholders(toFormat, {
          ":coll"      => Jekyll::Utils.slugify(collection.to_s, mode:slugify_mode, cased:slugify_cased),
          ":coll_name" => collection_name,
        })
      end #function format_coll_macro

      # Static: returns all documents from all collections defined in the hash of collections passed in
      # excludes all pagination pages though
      def self.collect_all_docs(site_collections)
        coll = []
        site_collections.each do |coll_name, coll_data|
          if !coll_data.nil? 
            coll += coll_data.docs.select { |doc| !doc.data.has_key?('pagination') }.each{ |doc| doc.data['__coll'] = coll_name } # Exclude all pagination pages and then for every page store it's collection name
          end
        end
        return coll
      end

      def self.ap_index_posts_by(all_posts, index_key)
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
            key = key.strip
            # If the key is a delimetered list of values 
            # (meaning the user didn't use an array but a string with commas)
            key.split(/;|,/).each do |raw_k_split|
              k_split = raw_k_split.to_s.downcase.strip #Clean whitespace and junk
              if !index.has_key?(k_split)
                # Need to store the original key value here so that I can present it to the users as a page variable they can use (unmodified, e.g. tags not being 'sci-fi' but "Sci-Fi")
                # Also, only interested in storing all the keys not the pages in this case
                index[k_split.to_s] = [k_split.to_s, raw_k_split.to_s]
              end
            end
          end
        end
        return index
      end # function index_posts_by

    end # class Utils

  end # module PaginateV2
end # module Jekyll
