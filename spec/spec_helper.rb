require 'minitest/spec'
require 'minitest/autorun'

require 'jekyll'
require_relative '../lib/jekyll-paginate-v2/defaults'
require_relative '../lib/jekyll-paginate-v2/utils'
require_relative '../lib/jekyll-paginate-v2/paginator'
require_relative '../lib/jekyll-paginate-v2/pagination'

# From: http://stackoverflow.com/a/32335990/779521
module MiniTest
  module Assertions
    def refute_raises *exp
      msg = "#{exp.pop}.\n" if String === exp.last

      begin
        yield
      rescue MiniTest::Skip => e
        return e if exp.include? MiniTest::Skip
        raise e
      rescue Exception => e
        exp = exp.first if exp.size == 1
        flunk "unexpected exception raised: #{e}"
      end

    end
  end
  module Expectations
    infect_an_assertion :refute_raises, :wont_raise
  end
end 