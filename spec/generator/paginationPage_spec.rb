require_relative '../spec_helper.rb'

RSpec.describe Jekyll::PaginateV2::Generator::PaginationPage do
  context "tesing pagination page implementation" do
    it "should always read the template file into itself" do
      # DUE TO THE JEKYLL:PAGE CLASS ACCESSING FILE IO DIRECTLY
      # I AM UNABLE TO MOCK OUT THE FILE OPERATIONS TO CREATE UNIT TESTS FOR THIS CLASS :/
    end
  end
end