# Jekyll::Paginate V2::AutoPages

**AutoPages** are an optional pagination addon that can automatically generate paginated pages for all your collections, tags and categories used in the pages on your site. This is useful if you have a large site where paginating the contents of your collections, tags or category lists provides a better user experience.

<p align="center">
  <img src="https://raw.githubusercontent.com/sverrirs/jekyll-paginate-v2/master/res/autopages-logo.png" height="128" />
</p>


> This feature is based on [code](https://github.com/stevecrozz/lithostech.com/blob/master/_plugins/tag_indexes.rb) written and graciously donated by [Stephen Crosby](https://github.com/stevecrozz). Thanks! :)

* [Site configuration](#site-configuration)
* [Advanced configuration](#advanced-configuration)
* [Specialised pages](#specialised-pages)
* [Example Sites](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples)
* [Common issues](#common-issues)

:warning: Please note, as of December 2016 this feature is still in **active development** and has not been released yet.

## Site configuration

``` yml
############################################################
# Site configuration for the Auto-Pages feature
# The values here represent the defaults if nothing is set
autopages:

  # Site-wide kill switch, disable here and it doesn't run at all 
  enabled: false

  # Category pages, omit to disable
  categories: 
    # Layout that should be processed for every category found in the site
    layouts: ['autopage_category.html'] 
    # The title that each category paginate page should get (:cat is replaced by the Category name)
    title: 'Posts in category :cat'
    # The permalink for the  pagination page (:cat is replaced), 
    # the pagination permalink path is then appended to this permalink structure
    permalink: '/category/:cat'

  # Collection pages, omit to disable
  collections:
    layouts: ['autopage_collection.html']
    title: 'Posts in collection :coll' # :coll is replaced by the collection name
    permalink: '/collection/:coll'
  
  # Tag pages, omit to disable
  tags:
    layouts: ['autopage_tags.html']
    title: 'Posts tagged with :tag' # :tag is replaced by the tag name
    permalink: '/tag/:tag'
```

## Simple configuration

## Advanced configuration

## Specialised pages

## Common issues
_None reported so far_