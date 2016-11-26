# Jekyll::Paginate V2

Pagination gem built specially for Jekyll 3 and newer.
https://rubygems.org/gems/jekyll-paginate-v2

Fully backwards compatable and enhanced replacement for the previously built-in [jekyll-paginate gem](https://github.com/jekyll/jekyll-paginate).

The code was based on the original design of [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) and features were mostly drawn from discussions from the issues pages (especially [#27](https://github.com/jekyll/jekyll-paginate/issues/27)) and some from the excellent [Octopress::Paginate code](https://github.com/octopress/paginate). 

:heart:


* [Installation](#installation)
* [Features](#features)
* [New site configuration](#site-configuration)
* [New page configuration](#page-configuration)
* [Backwards compatibility](#backwards-compatibility-with-jekyll-paginate)
* [How to paginate categories, tags, locales](#paginate-categories-tags-locales)
  + [Filtering categories](#filtering-categories)
  + [Filtering tags](#filtering-tags)
  + [Filtering locales](#filtering-locales)
* [How to paginate on combination of filters](#paginate-on-combination-of-filters)
* [Specifying configuration overrides](#configuration-overrides)
* [Common issues](#common-issues)
    - [Bundler error upgrading gem (Bundler::GemNotFound)](#im-getting-a-bundler-error-after-upgrading-the-gem-bundlergemnotfound)
* [Issues / to-be-completed](#issues--to-be-completed)
* [How to Contribute](#contributing)

## Installation

```
gem install jekyll-paginate-v2
```

Update your [_config.yml](#site-configuration) and [pages](#page-configuration).

> Although fully backwards compatible, to enable the new features this gem needs slightly extended [site yml](#site-configuration) configuration and miniscule additional new front-matter for the [pages to paginate on](#page-configuration).

Now you're ready to run `jekyll serve` and your paginated files should be generated.


## Features

In addition to all the features offered by the older [jekyll-paginate gem](https://github.com/jekyll/jekyll-paginate) this new pagination plugin features include

1. Works with any type of file ending (HTML, Markdown, etc) as long as the file has front-matter and the minimum page level pagination meta (see [page-configuration](#page-configuration)).
2. Paginated files can have any file name (not just index.html).
3. Supports category, tag and locale filtering.
4. Supports any combination of category, tag and locale filtering (e.g. _all posts in the 'ruby' category written for 'en\_US'_ or _all posts in 'car' and 'cycle' category tagged with 'cool' written for 'fr\_FR'_)
5. Sorting of posts by any field. Decending or Ascending.
6. Optional limits of number of pagenated pages (e.g. _only produce 15 pages_)
7. Fully customizable permalink format. E.g `/page:num/` or `/page/:num/` or `/:num/` or really anything you want.
8. Optional title suffix for paginated pages (e.g. _Index - Page 2_)

All this while being fully backwards compatible with the old [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) gem.

## Site configuration

The plugin can be configured in the site's `_config.yml` file by including the `pagination` configuration element

``` yml
############################################################
# Site configuration for the Jekyll 3 Pagination Plugin
# The values here represent the defaults if nothing is set
pagination:
  
  # Site-wide kill switch, disabled here it doesn't run at all 
  enabled: true

  # How many objects per paginated page, used to be `paginate` (default: 0, means all)
  per_page: 10

  # The permalink structure for the paginated pages (this can be any level deep)
  permalink: '/page/:num/'

  # Optional additional suffix for the title of the paginated pages (the prefix is inherited from the original page)
  title_suffix: ' - page :num'

  # Limit how many pagenated pages to create (default: 0, means all)
  limit: 0
  
  # Optional, defines the field that the posts should be sorted on (omit to default to 'date')
  sort_field: 'date'

  # Optional, sorts the posts in reverse order (omit to default decending or sort_reverse: true)
  sort_reverse: true

  # The default category to use, just leave this as 'posts' to get a backwards-compatible behavior (all posts)
  category: 'posts'

  # Optional, the default tag to use, omit to disable
  tag: 'cool'

  # Optional, the default locale to use, omit to disable (depends on a field 'locale' to be specified in the posts, 
  # in reality this can be any value, suggested are the Microsoft locale-codes (e.g. en_US, en_GB) or simply the ISO-639 language code )
  locale: 'en_US' 

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

## Common issues

#### I'm getting a bundler error after upgrading the gem (Bundler::GemNotFound)

> bundler/spec_set.rb:95:in `block in materialize': Could not find jekyll-paginate-v2-1.0.0 in any of the sources (Bundler::GemNotFound)

When running `jekyll serve` if you ever get an error similar to the one above the solution is to delete your `Gemfile.lock` file and try again.

#### My pagination pages are not being found (Couldn't find any pagination page. Skipping pagination)

> Pagination: Is enabled, but I couldn't find any pagination page. Skipping pagination...

Pagination only works inside **pages** they are not supported in the liquid templates. Those are the files that live in the folders prefixed by the underscore (i.e. files under `_layouts/`, `_includes/`, `_posts/` etc ). 

Create a normal page with a `layout:page` in it's front-matter and place the pagination logic there.

## Issues / to-be-completed
* Incomplete unit-tests 
* Missing integration tests [#2](https://github.com/jekyll/jekyll-paginate/pull/2)
* Missing more detailed examples
* Unable to auto-generate category/tag/language pagination pages. Still requires programmer to specify the pages him/herself.
* _Exclude_ filter not implemented [#6](https://github.com/jekyll/jekyll-paginate/issues/6)

## Contributing

I currently need testers and people willing to give me feedback and code reviews.

1. Fork it ( https://github.com/sverrirs/jekyll-paginate-v2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the unit tests (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Build the gem locally (`gem build jekyll-paginate-v2.gemspec`)
6. Test and verify the gem locally (`gem install ./jekyll-paginate-v2-x.x.x.gem`) 
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

Note: This project uses [semantic versioning](http://semver.org/).