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
      attr_reader :relative_path

      def initialize(page_to_copy, cur_page_nr, total_pages, index_pageandext)
        @site = page_to_copy.site
        @base = ''
        @url  = ''
        @relative_path = page_to_copy.relative_path

        if cur_page_nr == 1
          @dir = File.dirname(page_to_copy.dir)
          @name = page_to_copy.name
        else
          @name = index_pageandext.nil? ? 'index.html' : index_pageandext
        end

        self.process(@name) # Creates the basename and ext member values

        # Copy page data over site defaults
        defaults = @site.frontmatter_defaults.all(page_to_copy.relative_path, type)
        self.data = Jekyll::Utils.deep_merge_hashes(defaults, page_to_copy.data)

        if defaults.has_key?('permalink')
          self.data['permalink'] = Jekyll::URL.new(:template => defaults['permalink'], :placeholders => self.url_placeholders).to_s
          @use_permalink_for_url = true
        end

        if !page_to_copy.data['autopage']
          self.content = page_to_copy.content
        else
          # If the page is an auto page then migrate the necessary autopage info across into the
          # new pagination page (so that users can get the correct keys etc)
          if( page_to_copy.data['autopage'].has_key?('display_name') )
            self.data['autopages'] = Jekyll::Utils.deep_merge_hashes( page_to_copy.data['autopage'], {} )
          end
        end

        # Store the current page and total page numbers in the pagination_info construct
        self.data['pagination_info'] = {"curr_page" => cur_page_nr, 'total_pages' => total_pages }       

        # Perform some validation that is also performed in Jekyll::Page
        validate_data! page_to_copy.path
        validate_permalink! page_to_copy.path

        # Trigger a page event
        #Jekyll::Hooks.trigger :pages, :post_init, self
      end

      def url=(url_value)
        @url = @use_permalink_for_url ? self.data['permalink'] : url_value
      end
      alias_method :set_url, :url=
    end # class PaginationPage

  end # module PaginateV2
end # module Jekyll
