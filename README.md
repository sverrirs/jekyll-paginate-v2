# Jekyll::Paginate V2

Pagination gem built specially for Jekyll 3 and newer and is a fully backwards compatable and enhanced replacement for the previously built-in [jekyll-paginate gem](https://github.com/jekyll/jekyll-paginate). View it on [rubygems.org](https://rubygems.org/gems/jekyll-paginate-v2).

[![Build Status](https://travis-ci.org/sverrirs/jekyll-paginate-v2.svg?branch=master)](https://travis-ci.org/sverrirs/jekyll-paginate-v2) 
[![Gem Version](https://badge.fury.io/rb/jekyll-paginate-v2.svg)](https://badge.fury.io/rb/jekyll-paginate-v2)
[![Dependency Status](https://gemnasium.com/badges/github.com/sverrirs/jekyll-paginate-v2.svg)](https://gemnasium.com/github.com/sverrirs/jekyll-paginate-v2)

Reach me at the [project issues](https://github.com/sverrirs/jekyll-paginate-v2/issues) section or via email at [jekyll@sverrirs.com](mailto:jekyll@sverrirs.com).

> The code was based on the original design of [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) and features were sourced discussions such as [#27](https://github.com/jekyll/jekyll-paginate/issues/27) (thanks [Günter Kits](https://github.com/gynter)).

* [Installation](#installation)
* [Example Sites](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples)
* [Site configuration](#site-configuration)
* [Page configuration](#page-configuration)
* [Backwards compatibility](#backwards-compatibility-with-jekyll-paginate)
* [Paginating collections](#paginating-collections)
  + [Single collection](#paginating-a-single-collection)
  + [Multiple collection](#paginating-multiple-collections)
  + [The special 'all' collection](#the-special-all-collection)
* [How to paginate categories, tags, locales](#paginate-categories-tags-locales)
  + [Filtering categories](#filtering-categories)
  + [Filtering tags](#filtering-tags)
  + [Filtering locales](#filtering-locales)
* [How to paginate on combination of filters](#paginate-on-combination-of-filters)
* [Overriding site configuration](#configuration-overrides)
* [Advanced Sorting](#advanced-sorting)
* [How to detect auto-generated pages](#detecting-generated-pagination-pages)
* [Common issues](#common-issues)
    - [Dependency Error after installing](#i-keep-getting-a-dependency-error-when-running-jekyll-serve-after-installing-this-gem)
    - [Bundler error upgrading gem (Bundler::GemNotFound)](#im-getting-a-bundler-error-after-upgrading-the-gem-bundlergemnotfound)
    - [Pagination pages are not found](#my-pagination-pages-are-not-being-found-couldnt-find-any-pagination-page-skipping-pagination)
    - [Categories cause excess folder nesting](#my-pages-are-being-nested-multiple-levels-deep)
    - [Pagination pages overwriting each others pages](#my-pagination-pages-are-overwriting-each-others-pages)
* [Issues / to-be-completed](#issues--to-be-completed)
* [How to Contribute](#contributing)

> _"Be excellent to each other"_

:heart:

## Installation

```
gem install jekyll-paginate-v2
```

Update your [_config.yml](#site-configuration) and [pages](#page-configuration).

> Although fully backwards compatible, to enable the new features this gem needs slightly extended [site yml](#site-configuration) configuration and miniscule additional new front-matter for the [pages to paginate on](#page-configuration).

Now you're ready to run `jekyll serve` and your paginated files should be generated.

Please see the [Examples](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples) for tips and tricks on how to configure the pagination logic.

## Site configuration

The plugin can be configured in the site's `_config.yml` file by including the `pagination` configuration element

``` yml
############################################################
# Site configuration for the Jekyll 3 Pagination Plugin
# The values here represent the defaults if nothing is set
pagination:
  
  # Site-wide kill switch, disabled here it doesn't run at all 
  enabled: true

  # Set to 'true' to enable pagination debugging. This can be enabled in the site config or only for individual pagination pages
  debug: false

  # The default document collection to paginate if nothing is specified ('posts' is default)
  collection: 'posts'

  # How many objects per paginated page, used to be `paginate` (default: 0, means all)
  per_page: 10

  # The permalink structure for the paginated pages (this can be any level deep)
  permalink: '/page/:num/'

  # Optional the title format for the paginated pages (supports :title for original page title, :num for pagination page number)
  title: ':title - page :num'

  # Limit how many pagenated pages to create (default: 0, means all)
  limit: 0
  
  # Optional, defines the field that the posts should be sorted on (omit to default to 'date')
  sort_field: 'date'

  # Optional, sorts the posts in reverse order (omit to default decending or sort_reverse: true)
  sort_reverse: true

  # Optional, the default category to use, omit or just leave this as 'posts' to get a backwards-compatible behavior (all posts)
  category: 'posts'

  # Optional, the default tag to use, omit to disable
  tag: ''

  # Optional, the default locale to use, omit to disable (depends on a field 'locale' to be specified in the posts, 
  # in reality this can be any value, suggested are the Microsoft locale-codes (e.g. en_US, en_GB) or simply the ISO-639 language code )
  locale: '' 

############################################################
```

Also ensure that you remove the old 'jekyll-paginate' gem from your `gems` list and add this new gem instead

``` yml
gems: [jekyll-paginate-v2]
```

## Page configuration

To enable pagination on a page then simply include the minimal pagination configuration in the page front-matter:

``` yml
---
layout: page
pagination: 
  enabled: true
---
```

Then you can use the normal `paginator.posts` logic to iterate through the posts.

``` html
{% for post in paginator.posts %}
  <h1>{{ post.title }}</h1>
{% endfor %}
```

And to display pagination links, simply

``` html
{% if paginator.total_pages > 1 %}
<ul>
  {% if paginator.previous_page %}
  <li>
    <a href="{{ paginator.previous_page_path | prepend: site.baseurl }}">Newer</a>
  </li>
  {% endif %}
  {% if paginator.next_page %}
  <li>
    <a href="{{ paginator.next_page_path | prepend: site.baseurl }}">Older</a>
  </li>
  {% endif %}
</ul>
{% endif %}
```

> All posts that have the `hidden: true` in their front matter are ignored by the pagination logic.

The code is fully backwards compatible and you will have access to all the normal paginator variables defined in the [official jekyll documentation](https://jekyllrb.com/docs/pagination/#liquid-attributes-available). 

Neat!

Don't delay, go see the [Examples](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples), they're way more useful than read-me docs at this point :)

## Backwards compatibility with jekyll-paginate
This gem is fully backwards compatible with the old [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) gem and can be used as a zero-configuration replacement for it. If the old site config is detected then the gem will fall back to the old logic of pagination. 

> You cannot run both the new pagination logic and the old one at the same time

The following `_config.yml` settings are honored when running this gem in compatability mode

``` yml
paginate: 8
paginate_path: "/legacy/page:num/"
```

See more about the old style of pagination at the [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) page.

> :bangbang: **Warning** Backwards compatibility with the old jekyll-paginate gem is currently scheduled to be removed after **1st January 2018**. Users will start receiving warning log messages when running jekyll two months before this date.

## Paginating collections
By default the pagination system only paginates `posts`. If you only have `posts` and `pages` in your site you don't need to worry about a thing, everything will work as intended without you configuring anything. 

However if you use document collections, or would like to, then this pagination gem offers extensive support for paginating documents in one or more collections at the same time. 

> Collections are groups of documents that belong together but should not be grouped by date. 
> See more about ['collections'](http://ben.balter.com/2015/02/20/jekyll-collections/) on Ben Balters blog.

### Paginating a single collection

Lets expand on Ben's collection discussion (linked above). Let's say that you have hundreds of cupcake pages in your cupcake collection. To create a pagination page for only documents from the cupcake collection you would do this

``` yml
---
layout: page
title: All Cupcakes
pagination: 
  enabled: true
  collection: cupcakes
---
```

### Paginating multiple collections

Lets say that you want to create a single pagination page for only small cakes on your page (you have both cupcakes and cookies to sell). You could do that like this

``` yml
---
layout: page
title: Lil'bits
pagination: 
  enabled: true
  collection: cupcakes, cookies
---
```

### The special 'all' collection

Now your site has grown and you have multiple cake collections on it and you want to have a single page that paginates all of your collections at the same time. 
You can use the special `all` collection name for this.

``` yml
---
layout: page
title: All the Cakes!
pagination: 
  enabled: true
  collection: all
---
```

> Note: Due to the `all` keyword being reserved for this feature, you cannot have a collection called `all` in your site configuration. Sorry. 


## Paginate categories, tags, locales

Enabling pagination for specific categories, tags or locales is as simple as adding values to the pagination page front-matter and corresponding values in the posts.

### Filtering categories

Filter single category 'software'

``` yml
---
layout: post
pagination: 
  enabled: true
  category: software
---
```

Filter multiple categories (lists only posts belonging to all categories)

``` yml
pagination: 
  enabled: true
  category: software, ruby
```

> To define categories you can either specify them in the front-matter or through the [directory structure](http://jekyllrb.com/docs/variables/#page-variables) of your jekyll site (Categories are derived from the directory structure above the \_posts directory). You can actually use both approaches to assign your pages to multiple categories.

### Filtering tags

Filter on a single tag

``` yml
pagination: 
  enabled: true
  tag: cool
```

Filter on multiple tags

``` yml
pagination: 
  enabled: true
  tag: cool, life
```

> When specifying tags in your posts make sure that the values are not enclosed in single quotes (double quotes are fine). If they are you will get a cryptic error when generating your site that looks like _"Error: could not read file <FILE>: did not find expected key while parsing a block mapping at line 2 column 1"_

### Filtering locales

In the case your site offers multiple languages you can include a `locale` item in your post front matter. The paginator can then use this value to filter on

The category page front-matter would look like this

``` yml
pagination: 
  enabled: true
  locale: en_US
```

Then for the relevant posts, include the `locale` variable in their front-matter

``` yml 
locale: en_US
```

## Paginate on combination of filters

Including only posts from categories 'ruby' and 'software' written in English

``` yml
pagination: 
  enabled: true
  category: software, ruby
  locale: en_US, en_GB, en_WW
```

Only showing posts tagged with 'cool' and in category 'cars'

``` yml
pagination: 
  enabled: true
  category: cars
  tag: cool
```

... and so on and so on

## Configuration overrides

All of the configuration elements from the `_config.yml` file can be overwritten in the pagination pages. E.g. if you want one category page to have different permalink structure simply override the item like so

``` yml
pagination: 
  enabled: true
  category: cars
  permalink: '/cars/:num/'
```

Overriding sorting to sort by the post title in ascending order for another paginated page could be done like so

``` yml
pagination: 
  enabled: true
  category: ruby
  sort_field: 'title'
  sort_reverse: false
```

## Advanced Sorting
Sorting can be done by any field that is available in the post front-matter. You can even sort by nested fields.

> When sorting by nested fields separate the fields with a colon `:` character.

As an example, assuming all your posts have the following front-matter

``` yml
---
layout: post
author:
  name: 
    first: "John"
    last: "Smith"
  born: 1960
---
```

You can define pagination sorting on the nested `first` field like so

``` yml
---
layout: page
title: "Authors by first name"
pagination: 
  enabled: true
  sort_field: 'author:name:first'
---
```

To sort by the `born` year in decending order (youngest first)

``` yml
---
layout: page
title: "Authors by birth year"
pagination: 
  enabled: true
  sort_field: 'author:born'
  sort_reverse: true
---
```

## Detecting generated pagination pages

To identify the auto-generated pages that are created by the pagination logic when iterating through collections such as `site.pages` the `page.autogen` variable can be used like so

```
{% for my_page in site.pages %}
  {% if my_page.title and my_page.autogen == nil %}
    <h1>{{ my_page.title | escape }}</h1>
  {% endif %}
{% endfor %}
```
_In this example only pages that have a title and are not auto-generated are included._

This variable is created and assigned the value `page.autogen = "jekyll-paginate-v2"` by the pagination logic. This way you can detect which pages are auto-generated and by what gem. 

## Common issues

### I keep getting a dependency error when running jekyll serve after installing this gem

> Dependency Error: Yikes! It looks like you don't have jekyll-paginate-v2 or one of its dependencies installed...

Check your `Gemfile` in the site root. Ensure that the jekyll-paginate-v2 gem is present in the jekyll_plugins group like the example below. If this group is missing add to the file.

``` ruby
group :jekyll_plugins do
  gem "jekyll-paginate-v2"
end
```

### I'm getting a bundler error after upgrading the gem (Bundler::GemNotFound)

> bundler/spec_set.rb:95:in `block in materialize': Could not find jekyll-paginate-v2-1.0.0 in any of the sources (Bundler::GemNotFound)

Delete your `Gemfile.lock` file and try again.

### My pagination pages are not being found (Couldn't find any pagination page. Skipping pagination)

> Pagination: Is enabled, but I couldn't find any pagination page. Skipping pagination...

* Ensure that you have the correct minimum front-matter in the pagination pages
``` yml
pagination:
  enabled: true
```
* You can place pagination logic into either the pages or liquid templates (templates are stored under the `_layouts/` and `_includes/` folders).

### My pages are being nested multiple levels deep

When using `categories` for posts it is advisable to explicitly state a `permalink` structure in your `_config.yml` file. 

```
permalink: /:year/:month/:title.html
```

This is because the default behavior in Jekyll is to nest pages for every category that they belong to and Jekyll unfortunately does not understand multi-categories separated with `,` or `;` but instead does all separation on `[space]` only. 

### My pagination pages are overwriting each others pages
If you specify multiple pages that paginate in the site root then you must give them unique and separate pagination permalink. This link is set in the pagination page front-matter like so

``` yml
pagination:
  enabled: true
  permalink: '/cars/:num/'
```

Make absolutely sure that your pagination permalink paths do not clash with any other paths in your final site. For simplicity it is recommended that you keep all custom pagination (non root index.html) in a single or multiple separate sub folders under your site root.

## Issues / to-be-completed
* A few missing unit-tests 
* No integration tests yet [#2](https://github.com/jekyll/jekyll-paginate/pull/2)
* _Exclude_ filter not implemented [#6](https://github.com/jekyll/jekyll-paginate/issues/6)
* Considering adding a feature to auto-generate collection/category/tag/locale pagination pages. In cases where projects have hundreds of tags creating the pages by hand is not a feasible option.

## Contributing

I currently really need testers for the gem and people willing to give me feedback and code reviews. 

If you don't want to open issues here on Github, you can also send me your feedback by email at [jekyll@sverrirs.com](mailto:jekyll@sverrirs.com).

1. Fork it ( https://github.com/sverrirs/jekyll-paginate-v2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the unit tests (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Build the gem locally (`gem build jekyll-paginate-v2.gemspec`)
6. Test and verify the gem locally (`gem install ./jekyll-paginate-v2-x.x.x.gem`) 
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

Note: This project uses [semantic versioning](http://semver.org/).