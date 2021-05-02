require_relative '../spec_helper.rb'

module Jekyll::PaginateV2::Generator
  describe PaginationIndexer do

    it "must intersect arrays" do
      first = [1, 2, 3, 4, nil]
      second = [2, 3, 4, 5]
      third = [3, 4, 5, 6]
      wildcard = [1, nil]

      first_second = PaginationIndexer.intersect_arrays(first, second)
      first_second.must_equal [2, 3, 4]

      first_wildcard = PaginationIndexer.intersect_arrays(first, wildcard)
      first_wildcard.must_equal [1, nil]

      not_wildcard = PaginationIndexer.intersect_arrays(first, second, third)
      not_wildcard.must_equal [3, 4]
    end

    it "must union arrays" do
      first = [1, 2, 3, 4, nil]
      second = [2, 3, 4, 5]
      third = [3, 4, 5, 6]
      wildcard = [1, nil]

      first_second = PaginationIndexer.union_arrays(first, second)
      first_second.must_equal [1, 2, 3, 4, nil, 5]

      first_wildcard = PaginationIndexer.union_arrays(first, wildcard)
      first_wildcard.must_equal [1, 2, 3, 4, nil]

      not_wildcard = PaginationIndexer.union_arrays(first, second, third)
      not_wildcard.must_equal [1, 2, 3, 4, nil, 5, 6]
    end
  end
end
