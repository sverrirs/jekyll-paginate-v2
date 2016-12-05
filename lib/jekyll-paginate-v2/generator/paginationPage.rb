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

      end
    end # class PaginationPage
  end # module PaginateV2
end # module Jekyll