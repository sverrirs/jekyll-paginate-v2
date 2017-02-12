module Jekyll
  module PaginateV2::AutoPages

    # The default configuration for the AutoPages
    DEFAULT = {
      'enabled'     => false,
      'tags'        => {
        'layouts'       => ['autopage_tags.html'],
        'title'         => 'Posts tagged with :tag',
        'permalink'     => '/tag/:tag',
        'enabled'       => true

      },
      'categories'  => {
        'layouts'       => ['autopage_category.html'],
        'title'         => 'Posts in category :cat',
        'permalink'     => '/category/:cat',
        'enabled'       => true
      },
      'collections' => {
        'layouts'       => ['autopage_collection.html'],
        'title'         => 'Posts in collection :coll',
        'permalink'     => '/collection/:coll',
        'enabled'       => true
      } 
    }

  end # module PaginateV2::AutoPages
end # module Jekyll
