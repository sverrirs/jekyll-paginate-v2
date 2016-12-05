module Jekyll
  module PaginateV2::Generator

    # The default configuration for the Paginator
    DEFAULT = {
      'enabled'      => false,
      'collection'   => 'posts',
      'per_page'     => 10,
      'permalink'    => '/page:num/', # Supports :num as customizable elements
      'title'        => ':title - page :num', # Supports :num as customizable elements
      'page_num'     => 1,
      'sort_reverse' => false,
      'sort_field'   => 'date',
      'limit'        => 0, # Limit how many content objects to paginate (default: 0, means all)
      'debug'        => false, # Turns on debug output for the gem
      'legacy'       => false # Internal value, do not use (will be removed after 2018-01-01)
    }

  end # module PaginateV2
end # module Jekyll