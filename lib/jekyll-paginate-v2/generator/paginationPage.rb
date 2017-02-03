module Jekyll
  module PaginateV2::Generator

    #
    # This page handles the creation of the fake pagination pages based on the original page configuration
    # The code does the same things as the default Jekyll/page.rb code but just forces the code to look
    # into the template instead of the (currently non-existing) pagination page.
    #
    # This page exists purely in memory and is not read from disk
    #
    class PaginationPage < Page
      def initialize(page_to_copy, ignored)
        @site = page_to_copy.site
        @base = ''
        @url = ''
        @name = 'index.html'

        self.process(@name) # Creates the basename and ext member values

        # Only need to copy the data part of the page as it already contains the layout information
        #self.data = Marshal.load(Marshal.dump(page_to_copy.data)) # Deep copying, http://stackoverflow.com/a/8206537/779521
        self.data = Jekyll::Utils.deep_merge_hashes( page_to_copy.data, {} )
        if !page_to_copy.data['autopage']
          self.content = page_to_copy.content
        else
          # If the page is an auto page then migrate the necessary autopage info across into the
          # new pagination page (so that users can get the correct keys etc)
          if( page_to_copy.data['autopage'].has_key?('display_name') )
            self.data['autopages'] = Jekyll::Utils.deep_merge_hashes( page_to_copy.data['autopage'], {} )
          end
        end

        # Perform some validation that is also performed in Jekyll::Page
        validate_data! page_to_copy.path
        validate_permalink! page_to_copy.path

        # Trigger a page event
        #Jekyll::Hooks.trigger :pages, :post_init, self
      end

      def set_url(url_value)
        @url = url_value
      end
    end # class PaginationPage

  end # module PaginateV2
end # module Jekyll