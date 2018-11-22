require_relative '../spec_helper.rb'

RSpec.describe Jekyll::PaginateV2::Generator::Utils do
  subject { described_class }

  context ".format_page_number" do
    it "should always replace num format with the specified number" do
      expect(subject.format_page_number( ":num",    7 )).to eq "7"
      expect(subject.format_page_number( ":num",   13 )).to eq "13"
      expect(subject.format_page_number( ":num",   -2 )).to eq "-2"
      expect(subject.format_page_number( ":num",    0 )).to eq "0"
      expect(subject.format_page_number( ":num", 1000 )).to eq "1000"
    end

    it "should always replace num format with the specified number and keep rest of formatting" do
      expect(subject.format_page_number( "/page:num/",  7 )).to eq "/page7/"
      expect(subject.format_page_number( "/page:num/", 50 )).to eq "/page50/"
      expect(subject.format_page_number( "/page:num/", -5 )).to eq "/page-5/"

      expect(subject.format_page_number( "/car/:num/",  1 )).to eq "/car/1/"
      expect(subject.format_page_number( "/car/:num",   1 )).to eq "/car/1"
      expect(subject.format_page_number( "car/:num",    1 )).to eq "car/1"
      expect(subject.format_page_number( "/car//:num",  1 )).to eq "/car//1"
    end

    it "make sure there is a leading slash in path" do
      expect(subject.ensure_leading_slash( "path/to/file/wow" )).to eq "/path/to/file/wow"
      expect(subject.ensure_leading_slash( "/no/place/wow/"   )).to eq "/no/place/wow/"
      expect(subject.ensure_leading_slash( "/no" )).to eq "/no"
      expect(subject.ensure_leading_slash( "no"  )).to eq "/no"
    end

    it "make sure there is never a leading slash in path" do
      expect(subject.remove_leading_slash( "path/to/file/wow" )).to eq "path/to/file/wow"
      expect(subject.remove_leading_slash( "/no/place/wow/"   )).to eq "no/place/wow/"
      expect(subject.remove_leading_slash( "/no" )).to eq "no"
      expect(subject.remove_leading_slash( "no"  )).to eq "no"
    end

    it "sort must sort strings lowercase" do
      expect(subject.sort_values( "AARON", "Aaron" )).to be_zero
      expect(subject.sort_values( "AARON", "aaron" )).to be_zero
      expect(subject.sort_values( "aaron", "AARON" )).to be_zero
    end

    it "when sorting by nested post data the values must be resolved fully" do
      data = {'book'=>{ 'name' => { 'first'=> 'John', 'last'=> 'Smith'}, 'rank'=>20}}
      expect(subject.sort_get_post_data( data, "book:rank"       )).to eq 20
      expect(subject.sort_get_post_data( data, "book:name:first" )).to eq "John"
      expect(subject.sort_get_post_data( data, "book:name:last"  )).to eq "Smith"

      expect(subject.sort_get_post_data( data, "book:name" )).to be_nil
      expect(subject.sort_get_post_data( data, "name"      )).to be_nil
      expect(subject.sort_get_post_data( data, "book"      )).to be_nil
    end

    it "should always replace max format with the specified number if specified" do
      expect(subject.format_page_number( ":num-:max",    7,   16 )).to eq "7-16"
      expect(subject.format_page_number( ":num-:max",   13,   20 )).to eq "13-20"
      expect(subject.format_page_number( ":num-:max",   -2,   -4 )).to eq "-2--4"
      expect(subject.format_page_number( ":num_of_:max", 0,   10 )).to eq "0_of_10"
      expect(subject.format_page_number( ":num/:max", 1000, 2000 )).to eq "1000/2000"
    end
  end
end

