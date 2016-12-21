# Jekyll::Paginate V2::AutoPages

The **AutoPages** are an optional pagination addon that automatically generates paginated pages for all your collections, tags and categories used in the pages on your site.

> This feature is based on [code](https://github.com/stevecrozz/lithostech.com/blob/master/_plugins/tag_indexes.rb) written and graciously donated by [Stephen Crosby](https://github.com/stevecrozz). Thanks! :)

* [Site configuration](#site-configuration)
* [Advanced configuration](#advanced-configuration)
* [Specialised pages](#specialised-pages)
* [Example Sites](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples)
* [Common issues](#common-issues)

:warning: This feature is still in active development and has not been released yet.

## Site configuration

``` yml
autopages:
  enabled: false
  categories: 
    layouts: ['autopage_category.html']
    title: 'Posts in category :cat'
    permalink: '/category/:cat'
  collections:
    layouts: ['autopage_collection.html']
    title: 'Posts in collection :coll'
    permalink: '/collection/:coll'
  tags:
    layouts: ['autopage_tags.html']
    title: 'Posts tagged with :tag'
    permalink: '/tag/:tag'
```

## Advanced configuration

## Specialised pages

## Common issues
_None reported so far_