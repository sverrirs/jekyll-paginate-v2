module Jekyll
  module PaginateV2

    # The default configuration for the Paginator
    DEFAULT = {
      'enabled'      => false,
      'collection'   => 'posts',
      'per_page'     => 10,
      'permalink'    => '/page:num/', # Supports :num as customizable elements
      'title_suffix' => ' - page :num', # Supports :num as customizable elements
      'page_num'     => 1,
      'sort_reverse' => false,
      'sort_field'   => 'date',
      'limit'        => 0, # Limit how many content objects to paginate (default: 0, means all)
      'legacy'       => false # Internal value, do not use (will be removed after 2018-01-01)
    }

  end # module PaginateV2
end # module Jekyll