module Jekyll
  module PaginateV2::AutoPages

    # The default configuration for the AutoPages
    DEFAULT = {
      'enabled'     => false,
      'tags'        => {
        'layouts'          => ['autopage_tags.html'],
        'title'            => 'Posts tagged with :tag',
        'permalink'        => '/tag/:tag'
      },
      'categories'  => {
        'layouts'       => ['autopage_category.html'],
        'title'         => 'Posts in category :cat',
        'permalink'     => '/category/:cat'
      },
      'collections' => {
        'layouts'       => ['autopage_collection.html'],
        'title'         => 'Posts in collection :coll',
        'permalink'     => '/collection/:coll'
      } 
    }

  end # module PaginateV2::AutoPages
end # module Jekyll