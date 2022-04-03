module Jekyll
  module PaginateV2::AutoPages

    class AutoPage < Jekyll::Page
      def initialize(site, autopage_config, pagination_config, coll_name, doc)
        @site = site
        @base = site.dest
        @name = 'index.html'

        layout_dir = '_layouts'

        # use layout in document priority, or specify one for it in the autopage config section
        # you need to have at least one of these specified. the autopage layout will be a fallback if none are sepcified
        layout_name = doc['layout'] || autopage_config['layout']
        layout_name += '.html'

        if coll_name.eql?('categories')
          index_key = 'category'
        elsif coll_name.eql?('tags')
          index_key = 'tag'
        else
          index_key = autopage_config['indexkey'].nil? ? coll_name : autopage_config['indexkey']
        end

        # used to do the pagination matching
        # defined in frontmatter like, author: Cherryleafroad
        # which matches the same in posts
        item = doc[index_key]

        # Path is only used by the convertible module and accessed below when calling read_yaml
        # Handling themes stored in a gem
        @path = if site.in_theme_dir(site.source) == site.source # we're in a theme
          site.in_theme_dir(site.source, layout_dir, layout_name)
        else
          site.in_source_dir(site.source, layout_dir, layout_name)
        end

        self.process(@name) # Creates the base name and extension
        self.read_yaml(File.join(site.source, layout_dir), layout_name)

        # Merge the config with any config that might already be defined in the layout
        pagination_layout_config = Jekyll::Utils.deep_merge_hashes(pagination_config, self.data['pagination'] || {})

        # Read any possible autopage overrides in the layout page
        autopage_layout_config = Jekyll::Utils.deep_merge_hashes(autopage_config, self.data['autopages'] || {})

        # Construct the title
        # as usual, you have 3 different options for title
        # you can use cased to get upper or lower case on the key if using ap config title
        item_cased = autopage_config['cased'] ? item : item.downcase
        ap_title = autopage_config['title']&.gsub(":#{index_key}", item_cased)
        page_title = ap_title || autopage_layout_config['title'] || doc['title']

        # NOTE: Should we set this before calling read_yaml as that function validates the permalink structure
        # use doc permalink if available
        # Get permalink structure
        # ap permalink setting overrides document setting
        # It MUST be a directory notation NOT a file ending
        ap_perma = autopage_config['permalink']&.gsub(":#{index_key}", item_cased)
        permalink = ap_perma || doc.url.to_s
        self.data['permalink'] = permalink
        @url = File.join(permalink, @name)
        @dir = permalink

        # set up pagination
        if coll_name.eql?('categories') or coll_name.eql?('tags')
          pagination_layout_config[index_key] = doc[index_key]
        else
          # user definable different collections, or default
          pagination_layout_config['collection'] = autopage_config['collection'] || pagination_config['collection'] || 'posts'
          pagination_layout_config[index_key] = doc[index_key]
          pagination_layout_config['filter_coll_by'] = index_key if autopage_config['filter_collection']
        end

        # use ap config layout or doc layout. ap overrides doc layout
        self.data['layout'] = autopage_config['layout'] || doc.data['layout']
        # use the docs title first if available
        self.data['title'] = page_title
        # inject pagination variable
        self.data['pagination'] = pagination_layout_config # Store the pagination configuration

        # inject the rest of the frontmatter data into the page as if it was originating from the original page
        ignore_keys = %w[layout title permalink autopages]
        # include all data unless it's a disallowed key
        doc.data.each do |key, value|
          if key == 'excerpt'
            value = value.output.strip
          end

          self.data[key] = value unless ignore_keys.include?(key)
        end

        unless doc.content.nil?
          # run renderer on document to render out data to get the rendered content
          doc.renderer.run
          # set content separately since it's not part of data
          self.data['content'] = doc.content.strip.empty? ? nil : doc.content.strip
        end

        # Add the auto page flag in there to be able to detect the page (necessary when figuring out where to load it from)
        # TODO: Need to re-think this variable!!!
        self.data['autopage'] = {'layout_path' => File.join( layout_dir, layout_name ), 'display_name' => item }

        data.default_proc = proc do |_, key|
          site.frontmatter_defaults.find(File.join(layout_dir, layout_name), type, key)
        end

        # Trigger a page event
        #Jekyll::Hooks.trigger :pages, :post_init, self
      end #function initialize
    end #class BaseAutoPage
  end # module PaginateV2
end # module Jekyll
