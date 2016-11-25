require_relative 'spec_helper.rb'

module Jekyll::PaginateV2
  describe Paginator do

    it "must include the necessary paginator attributes" do

      pager = Paginator.new(10, "/page:num/", [], 1, 10, "/index.md")

      err = ->{ pager.page }.wont_raise NoMethodError
      err = ->{ pager.per_page }.wont_raise NoMethodError
      err = ->{ pager.posts }.wont_raise NoMethodError
      err = ->{ pager.total_posts }.wont_raise NoMethodError
      err = ->{ pager.total_pages }.wont_raise NoMethodError
      err = ->{ pager.previous_page }.wont_raise NoMethodError
      err = ->{ pager.previous_page_path }.wont_raise NoMethodError
      err = ->{ pager.next_page }.wont_raise NoMethodError
      err = ->{ pager.next_page_path }.wont_raise NoMethodError
      
    end

    it "must throw an error if the current page number is greater than the total pages" do
      err = -> { pager = Paginator.new(10, "/page:num/", [], 10, 8, "/index.md") }.must_raise RuntimeError
      err = -> { pager = Paginator.new(10, "/page:num/", [], 8, 10, "/index.md") }.wont_raise RuntimeError
    end

    it "must trim the list of posts correctly based on the cur_page_nr and per_page" do
      # Create a dummy list of posts that is easy to track
      posts = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35']

      # Initialize a pager with
      #   5 posts per page
      #   at page 2 out of 5 pages
      pager = Paginator.new(5, "/page:num/", posts, 2, 5, "/index.md")

      pager.page.must_equal 2
      pager.per_page.must_equal 5
      pager.total_pages.must_equal 5

      pager.total_posts.must_equal 35

      pager.posts.size.must_equal 5
      pager.posts[0].must_equal '6'
      pager.posts[4].must_equal '10'

      pager.previous_page.must_equal 1
      pager.previous_page_path.must_equal '/index.md'
      pager.next_page.must_equal 3
      pager.next_page_path.must_equal '/page3/'
    end

    it "must not create a previous page if we're at first page" do
      # Create a dummy list of posts that is easy to track
      posts = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35']

      # Initialize a pager with
      #   5 posts per page
      #   at page 2 out of 5 pages
      pager = Paginator.new(5, "/page:num/", posts, 1, 5, "/index.md")

      pager.page.must_equal 1
      pager.per_page.must_equal 5
      pager.total_pages.must_equal 5

      pager.total_posts.must_equal 35

      pager.posts.size.must_equal 5
      pager.posts[0].must_equal '1'
      pager.posts[4].must_equal '5'

      pager.previous_page.must_be_nil
      pager.previous_page_path.must_be_nil
      pager.next_page.must_equal 2
      pager.next_page_path.must_equal '/page2/'
    end

    it "must not create a next page if we're at the final page" do
      # Create a dummy list of posts that is easy to track
      posts = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35']

      # Initialize a pager with
      #   5 posts per page
      #   at page 2 out of 5 pages
      pager = Paginator.new(5, "/page:num/", posts, 5, 5, "/index.md")

      pager.page.must_equal 5
      pager.per_page.must_equal 5
      pager.total_pages.must_equal 5

      pager.total_posts.must_equal 35

      pager.posts.size.must_equal 5
      pager.posts[0].must_equal '21'
      pager.posts[4].must_equal '25'

      pager.previous_page.must_equal 4
      pager.previous_page_path.must_equal '/page4/'
      pager.next_page.must_be_nil
      pager.next_page_path.must_be_nil
    end

  end
end
