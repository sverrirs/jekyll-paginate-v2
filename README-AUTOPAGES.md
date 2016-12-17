# Jekyll::Paginate V2::AutoPages

The **AutoPages** are an optional pagination addon that automatically generates paginated pages for all your collections, tags and categories used in the pages on your site.

> This feature is based on [code](https://github.com/stevecrozz/lithostech.com/blob/master/_plugins/tag_indexes.rb) written and graciously donated by [Stephen Crosby](https://github.com/stevecrozz). Thanks! :)

* [Site configuration](#site-configuration)
* [Advanced configuration](#advanced-configuration)
* [Specialised pages](#specialised-pages)
* [Example Sites](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples)
* [Common issues](#common-issues)

## Site configuration

``` yml
autopages:
  enabled: false
  categories: 
    layouts: ['autopage_category.html']
    title: 'Posts in category :cat'
    permalink: '/category/:cat'

    # In addition all the pagination settings can also be defined here
    enabled: false
    debug: false
    collection: 'posts'
    per_page: 10
    limit: 0
    sort_field: 'date'
    sort_reverse: true
    category: 'posts'
    tag: ''
    locale: '' 

  collections:
    layouts: ['autopage_collection.html']
    title: 'Posts in collection :coll'
    permalink: '/collection/:coll'
    # ... default pagination configuration items ...
  tags:
    layouts: ['autopage_tags.html']
    title: 'Posts tagged with :tag'
    permalink: '/tag/:tag'
    #... other pagination configuration items ...
```

## Advanced configuration

## Specialised pages

## Common issues
_None reported so far_