require_relative '../spec_helper.rb'

RSpec.describe Jekyll::PaginateV2::Generator::Paginator do
  let(:per_page) { 10 }
  let(:first_index_page_url) { "index.html" }
  let(:paginated_page_url)   { "/page:num/" }
  let(:posts) { [] }
  let(:cur_page_nr) { 1 }
  let(:num_pages)   { 10 }

  let(:basename)  { "index" }
  let(:extension) { ".html" }

  subject do
    described_class.new(
      per_page, first_index_page_url, paginated_page_url, posts, cur_page_nr, num_pages, basename, extension
    )
  end
  alias_method :pager, :subject

  it "should have the necessary paginator attributes" do
    expect( pager.page ).to eql 1
    expect( pager.per_page ).to eql 10
    expect( pager.posts ).to eql []
    expect( pager.total_posts ).to eql 0
    expect( pager.total_pages ).to eql 10
    expect( pager.previous_page ).to be_nil
    expect( pager.previous_page_path ).to be_nil
    expect( pager.next_page ).to eql 2
    expect( pager.next_page_path ).to eql "/page2/index.html"
  end

  context "initializing with current page number greater than the total pages" do
    let(:cur_page_nr) { 10 }
    let(:num_pages)   { 8 }

    it "should throw an error" do
      expect { subject }.to raise_error(
        RuntimeError, "page number can't be greater than total pages: 10 > 8"
      )
    end
  end

  context "with a list of posts" do
    # Create a dummy list of posts that is easy to track (buckets)
    let(:posts) do
      [
         '1',  '2',  '3',  '4',  '5',
         '6',  '7',  '8',  '9', '10',
        '11', '12', '13', '14', '15',
        '16', '17', '18', '19', '20',
        '21', '22', '23', '24', '25',
        '26', '27', '28', '29', '30',
        '31', '32', '33', '34', '35'
      ]
    end

    # Initialize a pager with
    #   5 posts per page
    #   at page 2 out of 5 pages
    #
    # pager = Paginator.new(5, "index.html", "/page:num/", posts, 2, 5, "", "")
    #
    # current bucket: ["6", "7", "8", "9", "10"]
    #
    let(:per_page)    { 5 }
    let(:cur_page_nr) { 2 }
    let(:num_pages)   { 5 }

    let(:basename)    { "" }
    let(:extension)   { "" }

    it "must trim the list of posts correctly based on the cur_page_nr and per_page" do
      expect( pager.per_page ).to eq 5
      expect( pager.page ).to eq 2
      expect( pager.total_pages ).to eq 5

      expect( pager.total_posts ).to eq 35

      expect( pager.posts.size ).to eq 5
      expect( pager.posts[0] ).to eq "6"
      expect( pager.posts[4] ).to eq "10"

      expect( pager.previous_page ).to eq 1
      expect( pager.previous_page_path ).to eq "index.html"
      expect( pager.next_page ).to eq 3
      expect( pager.next_page_path ).to eq "/page3/"
    end

    context "with index basename and extension specified" do
      # pager = Paginator.new(5, "index.html", "/page:num/", posts, 2, 5, "index", ".html")
      #
      # current bucket: ["6", "7", "8", "9", "10"]
      #
      let(:basename)  { "index" }
      let(:extension) { ".html" }

      it "should create the index page with extension" do
        expect( pager.per_page ).to eq 5
        expect( pager.page ).to eq 2
        expect( pager.total_pages ).to eq 5

        expect( pager.total_posts ).to eq 35

        expect( pager.posts.size ).to eq 5
        expect( pager.posts[0] ).to eq "6"
        expect( pager.posts[4] ).to eq "10"

        expect( pager.previous_page ).to eq 1
        expect( pager.previous_page_path ).to eq "index.html"
        expect( pager.next_page ).to eq 3
        expect( pager.next_page_path ).to eq "/page3/index.html"
      end
    end

    context "with index basename template and extension specified" do
      # pager = Paginator.new(5, "/", "/", posts, 2, 5, "feed:num", ".json")
      #
      # current bucket: ["6", "7", "8", "9", "10"]
      #
      let(:first_index_page_url) { "/" }
      let(:paginated_page_url) { "/" }
      let(:basename)  { "feed:num" }
      let(:extension) { ".json" }

      it "should create the index page with specified extension" do
        expect( pager.per_page ).to eq 5
        expect( pager.page ).to eq 2
        expect( pager.total_pages ).to eq 5

        expect( pager.total_posts ).to eq 35

        expect( pager.posts.size ).to eq 5
        expect( pager.posts[0] ).to eq "6"
        expect( pager.posts[4] ).to eq "10"

        expect( pager.page_path ).to eq "/feed2.json"

        expect( pager.previous_page ).to eq 1
        expect( pager.previous_page_path ).to eq "/feed1.json"
        expect( pager.next_page ).to eq 3
        expect( pager.next_page_path ).to eq "/feed3.json"
      end
    end

    context "at the first page" do
      # pager = Paginator.new(5, "index.html", "/page:num/", posts, 1, 5, "", "")
      #
      # current bucket: ["1", "2", "3", "4", "5"]
      #
      let(:cur_page_nr) { 1 }

      it "should not create a previous page" do
        expect( pager.per_page ).to eq 5
        expect( pager.page ).to eq 1
        expect( pager.total_pages ).to eq 5

        expect( pager.total_posts ).to eq 35

        expect( pager.posts.size ).to eq 5
        expect( pager.posts[0] ).to eq "1"
        expect( pager.posts[4] ).to eq "5"

        expect( pager.previous_page ).to be_nil
        expect( pager.previous_page_path ).to be_nil
        expect( pager.next_page ).to eq 2
        expect( pager.next_page_path ).to eq "/page2/"
      end
    end

    context "at the final page" do
      # pager = Paginator.new(5, "index.html", "/page:num/", posts, 5, 5, "", "")
      #
      # current bucket: ["21", "22", "23", "24", "25"]
      #
      let(:cur_page_nr) { 5 }

      it "should not create a next page" do
        expect( pager.per_page ).to eq 5
        expect( pager.page ).to eq 5
        expect( pager.total_pages ).to eq 5

        expect( pager.total_posts ).to eq 35

        expect( pager.posts.size ).to eq 5
        expect( pager.posts[0] ).to eq "21"
        expect( pager.posts[4] ).to eq "25"

        expect( pager.previous_page ).to eq 4
        expect( pager.previous_page_path ).to eq "/page4/"
        expect( pager.next_page ).to be_nil
        expect( pager.next_page_path ).to be_nil
      end
    end
  end
end
