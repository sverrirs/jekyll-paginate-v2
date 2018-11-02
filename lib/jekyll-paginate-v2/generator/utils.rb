module Jekyll 
  module PaginateV2::Generator

    #
    # Static utility functions that are used in the code and 
    # don't belong in once place in particular
    #
    class Utils

      # Static: Calculate the number of pages.
      #
      # all_posts - The Array of all Posts.
      # per_page  - The Integer of entries per page.
      #
      # Returns the Integer number of pages.
      def self.calculate_number_of_pages(all_posts, per_page)
        (all_posts.size.to_f / per_page.to_i).ceil
      end

      # Static: returns a fully formatted string with the current (:num) page number and maximum (:max) page count replaced if configured
      #
      def self.format_page_number(toFormat, cur_page_nr, total_page_count=nil)
        s = toFormat.sub(':num', cur_page_nr.to_s)
        if !total_page_count.nil?
          s = s.sub(':max', total_page_count.to_s)
        end
        return s
      end #function format_page_number

      # Static: returns a fully formatted string with the :title variable and the current (:num) page number and maximum (:max) page count replaced
      #
      def self.format_page_title(toFormat, title, cur_page_nr=nil, total_page_count=nil)
        return format_page_number(toFormat.sub(':title', title.to_s), cur_page_nr, total_page_count)
      end #function format_page_title

      # Static: Return a String version of the input which has a leading dot.
      #         If the input already has a dot in position zero, it will be
      #         returned unchanged.
      #
      # path - a String path
      #
      # Returns the path with a leading slash
      def self.ensure_leading_dot(path)
        path[0..0] == "." ? path : ".#{path}"
      end
      
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
      
      # Static: Return a String version of the input which has a trailing slash.
      #         If the input already has a forward slash at the end, it will be
      #         returned unchanged.
      #
      # path - a String path
      #
      # Returns the path with a trailing slash
      def self.ensure_trailing_slash(path)
        path[-1] == "/" ? path : "#{path}/"
      end

      #
      # Sorting routine used for ordering posts by custom fields.
      # Handles Strings separately as we want a case-insenstive sorting
      #
      def self.sort_values(a, b)
        if a.nil? && !b.nil?
          return -1
        elsif !a.nil? && b.nil?
          return 1
        end

        if a.is_a?(String)
          return a.downcase <=> b.downcase
        end

        if a.respond_to?('to_datetime') && b.respond_to?('to_datetime')
          return a.to_datetime <=> b.to_datetime
        end

        # By default use the built in sorting for the data type
        return a <=> b
      end

      # Retrieves the given sort field from the given post
      # the sort_field variable can be a hierarchical value on the form "parent_field:child_field" repeated as many times as needed
      # only the leaf child_field will be retrieved  
      def self.sort_get_post_data(post_data, sort_field)
        
        # Begin by splitting up the sort_field by (;,:.)
        sort_split = sort_field.split(":")
        sort_value = post_data

        sort_split.each do |r_key|
          key = r_key.downcase.strip # Remove any erronious whitespace and convert to lower case
          if !sort_value.has_key?(key)
            return nil
          end
          # Work my way through the hash
          sort_value = sort_value[key]
        end

        # If the sort value is a hash then return nil else return the value
        if( sort_value.is_a?(Hash) )
          return nil
        else
          return sort_value
        end
      end

      # Ensures that the passed in url has a index and extension applied
      def self.ensure_full_path(url, default_index, default_ext)
        if( url.end_with?('/'))
          return url + default_index + default_ext
        elsif !url.include?('.')
          return url + default_index
        end
        # Default
        return url
      end

      # Constructs the plural for a key
      def self.plural(config_key)
        (config_key =~ /s$/) ? config_key :
          (config_key.dup.sub!(/y$/, 'ies') || "#{config_key}s")
      end

      # Converts a string or array to a downcased, stripped array
      def self.config_array(config, key, keepcase = nil)
        [ config[key] ].flatten.compact.uniq.map { |c|
          c.split(/[,;]\s*/).map { |v|
            keepcase ? v.to_s.strip : v.to_s.downcase.strip
          }
        }.flatten.uniq
      end

      # Merges singular and plural config values into an array
      def self.config_values(config, key, keepcase = nil)
        singular = config_array(config, key, keepcase)
        plural = config_array(config, plural(key), keepcase)
        [ singular, plural ].flatten.uniq
      end

      def self.validate_url(template)
        url  = template.url
        ext  = template.output_ext
        path = Jekyll::URL.unescape_path(url)
        path = File.join(path, "index") if url.end_with?("/")
        path << ext unless path.end_with?(ext)

        dirname = File.dirname(path)
        valid_values = [
          File.join(dirname, "/"),
          File.join(dirname, "index#{ext}")
        ]

        return url if valid_values.include?(url)
        Jekyll.logger.error "Pagination Error:",
          "Detected invalid url #{url.inspect} for #{template.relative_path.inspect}"
        Jekyll.logger.abort_with "", "Expected #{valid_values.map(&:inspect).join(' or ')}"
      end
    end

  end # module PaginateV2
end # module Jekyll
