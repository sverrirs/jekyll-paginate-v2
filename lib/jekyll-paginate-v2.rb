# Jekyll::Paginate V2 is a gem built for Jekyll 3 that generates pagiatation for posts, categories and tags.
# 
# It is based on https://github.com/jekyll/jekyll-paginate, the original Jekyll paginator
# which was decommissioned in Jekyll 3 release onwards. This code is currently not officially
# supported on Jekyll versions < 3.0 (although it might work)
#
# Author: Sverrir Sigmundarson
# Site: https://github.com/sverrirs/jekyll-paginate-v2
# Distributed Under The MIT License (MIT) as described in the LICENSE file
#   - https://opensource.org/licenses/MIT

require "jekyll-paginate-v2/version"
require "jekyll-paginate-v2/defaults"
require "jekyll-paginate-v2/utils"
require "jekyll-paginate-v2/paginator"
require "jekyll-paginate-v2/pagination"

module Jekyll 
  module PaginateV2
  end # module PaginateV2
end # module Jekyll