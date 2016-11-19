require_relative 'spec_helper.rb'

module Jekyll::PaginateV2
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
      Utils.paginate_path(nil, nil, nil).must_be_nil
      Utils.paginate_path("/index/moore", nil, "/page:num/").must_be_nil
    end

    it "paginate must return the url to the template if cur_page_nr is equal to 1" do
      Utils.paginate_path("/index/moore", 1, "/page:num/").must_equal "/index/moore"
      Utils.paginate_path("/index.html", 1, "/page/").must_equal "/index.html"
    end

    it "paginate must throw an error if the permalink path doesn't include :num" do
      err = ->{ Utils.paginate_path("/index.html", 3, "/page/")}.must_raise ArgumentError
      err.message.must_include ":num"
    end

    it "paginate must use the permalink value and format it based on the cur_page_nr" do
      Utils.paginate_path("/index.html", 3, "/page:num/").must_equal "/page3/"
      Utils.paginate_path("/index.html", 646, "/page/:num/").must_equal "/page/646/"
    end

    it "paginate must ensure a leading slash in the url it returns" do
      Utils.paginate_path("/index.html", 3, "page:num/").must_equal "/page3/"
      Utils.paginate_path("/index.html", 646, "page/:num/").must_equal "/page/646/"
    end
  end
end

