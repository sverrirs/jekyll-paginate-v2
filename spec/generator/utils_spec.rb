require_relative '../spec_helper.rb'

module Jekyll::PaginateV2::Generator
  describe Utils do

    it "should always replace num format with the specified number" do
      Utils.format_page_number( ":num", 7).must_equal "7"
      Utils.format_page_number( ":num", 13).must_equal "13"
      Utils.format_page_number( ":num", -2).must_equal "-2"
      Utils.format_page_number( ":num", 0).must_equal "0"
      Utils.format_page_number( ":num", 1000).must_equal "1000"
    end

    it "should always replace num format with the specified number and keep rest of formatting" do
      Utils.format_page_number( "/page:num/", 7).must_equal "/page7/"
      Utils.format_page_number( "/page:num/", 50).must_equal "/page50/"
      Utils.format_page_number( "/page:num/", -5).must_equal "/page-5/"

      Utils.format_page_number( "/car/:num/", 1).must_equal "/car/1/"
      Utils.format_page_number( "/car/:num", 1).must_equal "/car/1"
      Utils.format_page_number( "car/:num", 1).must_equal "car/1"
      Utils.format_page_number( "/car//:num", 1).must_equal "/car//1"
    end

    it "make sure there is a leading slash in path" do
      Utils.ensure_leading_slash("path/to/file/wow").must_equal "/path/to/file/wow"
      Utils.ensure_leading_slash("/no/place/wow/").must_equal "/no/place/wow/"
      Utils.ensure_leading_slash("/no").must_equal "/no"
      Utils.ensure_leading_slash("no").must_equal "/no"
    end    

    it "make sure there is never a leading slash in path" do
      Utils.remove_leading_slash("path/to/file/wow").must_equal "path/to/file/wow"
      Utils.remove_leading_slash("/no/place/wow/").must_equal "no/place/wow/"
      Utils.remove_leading_slash("/no").must_equal "no"
      Utils.remove_leading_slash("no").must_equal "no"
    end

    it "paginate must return nil if cur_page_nr is nill" do
      Utils.paginate_path(nil, nil, nil, nil).must_be_nil
      Utils.paginate_path("/index/moore","/index/moore.md", nil, "/page:num/").must_be_nil
    end

    it "paginate must return the url to the template if cur_page_nr is equal to 1" do
      Utils.paginate_path("/index/moore", "/index/moore.md", 1, "/page:num/").must_equal "/index/moore"
      Utils.paginate_path("/index.html", "/index.html", 1, "/page/").must_equal "/index.html"
    end

    it "paginate must throw an error if the permalink path doesn't include :num" do
      err = ->{ Utils.paginate_path("/index.html", "/index.html", 3, "/page/")}.must_raise ArgumentError
      err.message.must_include ":num"
    end

    it "paginate must use the permalink value and format it based on the cur_page_nr" do
      Utils.paginate_path("/index.html", "/index.html", 3, "/page:num/").must_equal "/page3/"
      Utils.paginate_path("/index.html", "/index.html", 646, "/page/:num/").must_equal "/page/646/"
    end

    it "paginate must ensure a leading slash in the url it returns" do
      Utils.paginate_path("/index.html", "/index.html", 3, "page:num/").must_equal "/page3/"
      Utils.paginate_path("/index.html", "/index.html", 646, "page/:num/").must_equal "/page/646/"
    end

    it "paginate must pre-pend the template.path url to it if we're not at root" do
      Utils.paginate_path("/sub/index.html", "/sub/index.html", 3, "page:num/").must_equal "/sub/index/page3/"
      Utils.paginate_path("/sub/index", "/sub/index.html", 3, "page:num/").must_equal "/sub/index/page3/"
      Utils.paginate_path("/index/", "/sub/index.html", 3, "page:num/").must_equal "/index/page3/"
    end

    it "sort must sort strings lowercase" do
      Utils.sort_values( "AARON", "Aaron").must_equal 0
      Utils.sort_values( "AARON", "aaron").must_equal 0
      Utils.sort_values( "aaron", "AARON").must_equal 0 
    end

    it "when sorting by nested post data the values must be resolved fully" do
      data = {'book'=>{ 'name' => { 'first'=> 'John', 'last'=> 'Smith'}, 'rank'=>20}}
      Utils.sort_get_post_data(data, "book:rank").must_equal 20
      Utils.sort_get_post_data(data, "book:name:first").must_equal "John"
      Utils.sort_get_post_data(data, "book:name:last").must_equal "Smith"

      Utils.sort_get_post_data(data, "book:name").must_be_nil
      Utils.sort_get_post_data(data, "name").must_be_nil
      Utils.sort_get_post_data(data, "book").must_be_nil
    end


  end
end

