module Jekyll 
  module PaginateV2

    #
    # Static utility functions that are used in the code and 
    # don't belong in once place in particular
    #
    class Utils

      # Static: Return the pagination path of the page
      #
      # site     - the Jekyll::Site object
      # cur_page_nr - the pagination page number
      # config - the current configuration in use
      #
      # Returns the pagination path as a string
      def self.paginate_path(template, cur_page_nr, config)
        return nil if cur_page_nr.nil?
        return template.url if cur_page_nr <= 1
        format = config['permalink']
        if format.include?(":num")
          format = Utils.format_page_number(format, cur_page_nr)
        else
          raise ArgumentError.new("Invalid pagination path: '#{format}'. It must include ':num'.")
        end
        Utils.ensure_leading_slash(format)
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