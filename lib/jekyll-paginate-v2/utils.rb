module Jekyll 
  module PaginateV2

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

      # Static: Return the pagination path of the page
      #
      # site     - the Jekyll::Site object
      # cur_page_nr - the pagination page number
      # config - the current configuration in use
      #
      # Returns the pagination path as a string
      def self.paginate_path(template_url, template_path, cur_page_nr, permalink_format)
        return nil if cur_page_nr.nil?
        return template_url if cur_page_nr <= 1
        if permalink_format.include?(":num")
          permalink_format = Utils.format_page_number(permalink_format, cur_page_nr)
        else
          raise ArgumentError.new("Invalid pagination path: '#{permalink_format}'. It must include ':num'.")
        end

        # If the template url is not just root "/" then pre-pend the template_url path to it
        template_dir = File.dirname(template_path)
        if( template_dir != "" && template_dir != "/" )
          permalink_format = File.join(template_url, permalink_format)
        end

        Utils.ensure_leading_slash(permalink_format)
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

    end

  end # module PaginateV2
end # module Jekyll