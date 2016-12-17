module Jekyll
  module PaginateV2::AutoPages

    # NOTE!!! Don't do this like this. We don't need pagination configuration merged into this
    # just read the config from the site, merge it to what ever is in the layout and apply that as default 
    # that's it!

    # The default configuration for the AutoPages
    DEFAULT = {
      'enabled'     => false,
      'tags'        => {
        'layouts'          => ['autopage_tags.html'],
        'title'            => 'Posts tagged with :tag',
        'permalink'        => '/tag/:tag'
        #'permalink_suffix' => ':num'
      },
      'categories'  => {
        'layouts'       => ['autopage_category.html'],
        'title'         => 'Posts in category :cat',
        'permalink'     => '/category/:cat'
        #'permalink_suffix' => ':num'
      },
      'collections' => {
        'layouts'       => ['autopage_collection.html'],
        'title'         => 'Posts in collection :coll',
        'permalink'     => '/collection/:coll'
        #'permalink_suffix' => ':num'
      } 
    }

  end # module PaginateV2
end # module Jekyll