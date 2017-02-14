module Jekyll
  module PaginateV2::Generator
    
    #
    # Handles the preparation of all the posts based on the current page index
    #
    class Paginator
      attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
        :previous_page, :previous_page_path, :next_page, :next_page_path, :page_path, :page_trail

      def page_trail
        @page_trail
      end

      def page_trail=(page_array)
        @page_trail = page_array
      end
      
      # Initialize a new Paginator.
      #
      def initialize(config_per_page, first_index_page_url, paginated_page_url, posts, cur_page_nr, num_pages)
        @page = cur_page_nr
        @per_page = config_per_page.to_i
        @total_pages = num_pages

        if @page > @total_pages
          raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
        end

        init = (@page - 1) * @per_page
        offset = (init + @per_page - 1) >= posts.size ? posts.size : (init + @per_page - 1)

        @total_posts = posts.size
        @posts = posts[init..offset]
        @page_path = @page == 1 ? first_index_page_url : Utils.format_page_number(paginated_page_url, cur_page_nr, @total_pages)
        @previous_page = @page != 1 ? @page - 1 : nil
        @previous_page_path = @page != 1 ? @page == 2 ? first_index_page_url : Utils.format_page_number(paginated_page_url, @previous_page, @total_pages) : nil
        @next_page = @page != @total_pages ? @page + 1 : nil
        @next_page_path = @page != @total_pages ? Utils.format_page_number(paginated_page_url, @next_page, @total_pages) : nil
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
          'page_trail' => page_trail
        }
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
          'path' => path+"index.html",
          'title' => title
        }
      end
    end #class PageTrail

  end # module PaginateV2
end # module Jekyll
