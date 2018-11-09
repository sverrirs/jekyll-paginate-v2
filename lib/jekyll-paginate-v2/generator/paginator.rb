module Jekyll
  module PaginateV2::Generator
    
    #
    # Handles the preparation of all the posts based on the current page index
    #
    class Paginator
      attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
        :previous_page, :previous_page_path, :next_page, :next_page_path, :page_path, :page_trail,
        :first_page, :first_page_path, :last_page, :last_page_path

      def page_trail=(page_array)
        @page_trail = page_array
      end
      
      # Initialize a new Paginator.
      #
      def initialize(config_per_page, first_index_page_url, paginated_page_url, posts, cur_page_nr, num_pages, default_indexpage, default_ext)
        @page = cur_page_nr
        @per_page = config_per_page.to_i
        @total_pages = num_pages

        # RuntimeError is raised by default
        if @page > @total_pages
          raise "page number can't be greater than total pages: #{@page} > #{@total_pages}"
        end

        init  = (@page - 1) * @per_page
        count = init + @per_page - 1

        # get the smaller of two values
        offset = [count, posts.size].min

        # Ensure that default attributes are neither `nil` nor `false`
        default_indexpage ||= ''
        default_ext ||= ''

        # Ensure that the current page has correct extensions if needed
        page_url = @page == 1 ? first_index_page_url : paginated_page_url
        basename = default_indexpage.empty? ? 'index' : default_indexpage
        ext_name = default_ext.empty? ? '.html' : default_ext

        this_page_url = Utils.ensure_full_path(page_url, basename, ext_name)
        
        # To support customizable pagination pages we attempt to explicitly append the page name to 
        # the url in case the user is using extensionless permalinks.
        unless default_indexpage.empty?
          first_index_page_url = Utils.ensure_full_path(first_index_page_url, default_indexpage, default_ext)
          paginated_page_url   = Utils.ensure_full_path(paginated_page_url, default_indexpage, default_ext)
        end        

        @total_posts = posts.size
        @posts       = posts[init..offset]
        @page_path   = _format_page_number(this_page_url, cur_page_nr)

        _setup_paginator_pages(first_index_page_url, paginated_page_url)
      end

      # Convert this Paginator's data to a Hash suitable for use by Liquid.
      #
      # Returns the Hash representation of this Paginator.
      def to_liquid
        {
          'per_page' => per_page,
          'posts' => posts,
          'total_posts' => total_posts,
          'total_pages' => total_pages,
          'page' => page,
          'page_path' => page_path,
          'previous_page' => previous_page,
          'previous_page_path' => previous_page_path,
          'next_page' => next_page,
          'next_page_path' => next_page_path,
          'first_page' => first_page,
          'first_page_path' => first_page_path,
          'last_page' => last_page,
          'last_page_path' => last_page_path,
          'page_trail' => page_trail
        }
      end

      private

      def _setup_paginator_pages(first_index_page_url, paginated_page_url)
        # Setup prev pages
        # First page has no "previous page" link
        unless @page == 1
          pager_page_url = @page == 2 ? first_index_page_url : paginated_page_url
          @previous_page = @page - 1
          @previous_page_path = _format_page_number(pager_page_url, @previous_page)
        end

        # Setup next pages
        # Last page has no "next page" link
        unless @page == @total_pages
          @next_page = @page + 1
          @next_page_path = _format_page_number(paginated_page_url, @next_page)
        end

        # Setup the first page
        # Every other page knows the first page
        @first_page = 1
        @first_page_path = _format_page_number(first_index_page_url, @first_page)

        # Setup the last page
        # Every other page knows the last page
        @last_page = @total_pages
        @last_page_path = _format_page_number(paginated_page_url, @last_page)

        # return nothing
        nil
      end

      def _format_page_number(url, page_number)
        Utils.format_page_number(url, page_number, @total_pages)
      end
      
    end # class Paginator

    # Small utility class that handles individual pagination trails 
    # and makes them easier to work with in Liquid
    class PageTrail
      attr_reader :num, :path, :title

      def initialize( num, path, title )
        @num = num
        @path = path
        @title = title
      end #func initialize

      def to_liquid
        {
          'num' => num,
          'path' => path,
          'title' => title
        }
      end
    end #class PageTrail

  end # module PaginateV2
end # module Jekyll