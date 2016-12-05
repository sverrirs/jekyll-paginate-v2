module Jekyll
  module PaginateV2::Generator
    
    #
    # Handles the preparation of all the posts based on the current page index
    #
    class Paginator
      attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
        :previous_page, :previous_page_path, :next_page, :next_page_path
      
      # Initialize a new Paginator.
      #
      # site     - the Jekyll::Site object
      # page_nr  - The Integer page number.
      # all_posts - The Array of all the site's Posts.
      # num_pages - The Integer number of pages or nil if you'd like the number
      #             of pages calculated.
      def initialize(config_per_page, config_permalink, posts, cur_page_nr, num_pages, template_url, template_path )
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
        @previous_page = @page != 1 ? @page - 1 : nil
        @previous_page_path = @page != 1 ? Utils.paginate_path(template_url, template_path, @previous_page, config_permalink) : nil
        @next_page = @page != @total_pages ? @page + 1 : nil
        @next_page_path = @page != @total_pages ? Utils.paginate_path(template_url, template_path, @next_page, config_permalink) : nil
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
          'previous_page' => previous_page,
          'previous_page_path' => previous_page_path,
          'next_page' => next_page,
          'next_page_path' => next_page_path
        }
      end
      
    end # class Paginator

  end # module PaginateV2
end # module Jekyll