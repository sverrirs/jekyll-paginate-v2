module Jekyll
  module PaginateV2::Generator

    #
    # This page handles the creation of the fake pagination pages based on the original page configuration
    # The code does the same things as the default Jekyll/page.rb code but just forces the code to look
    # into the template instead of the (currently non-existing) pagination page.
    #
    class PaginationPage < Page
      def initialize(site, base, dir, template_path)
        @site = site
        @base = base
        @dir = dir
        @template = template_path
        @name = 'index.html'

        templ_dir = File.dirname(template_path)
        templ_file = File.basename(template_path)

        # Path is only used by the convertible module and accessed below when calling read_yaml
        # in our case we have the path point to the original template instead of our faux new pagination page
        @path = if site.in_theme_dir(base) == base # we're in a theme
                  site.in_theme_dir(base, templ_dir, templ_file)
                else
                  site.in_source_dir(base, templ_dir, templ_file)
                end
        
        self.process(@name)
        self.read_yaml(templ_dir, templ_file)

        data.default_proc = proc do |_, key|
          site.frontmatter_defaults.find(File.join(templ_dir, templ_file), type, key)
        end

        # Should we trigger?
        Jekyll::Hooks.trigger :pages, :post_init, self
      end
    end # class PaginationPage

    class PaginationPageInMemory < Page
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