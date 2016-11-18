# Jekyll::Paginate V2

Pagination gem built specially for Jekyll 3 and newer.
https://rubygems.org/gems/jekyll-paginate-v2

Fully backwards compatable and enhanced replacement for the previously built-in [jekyll-paginate gem](https://github.com/jekyll/jekyll-paginate).

The code was based on the original design of [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) and features were mostly drawn from discussions from the issues pages (especially [#27](https://github.com/jekyll/jekyll-paginate/issues/27)) and some from the excellent [Octopress::Paginate code](https://github.com/octopress/paginate). 

:heart:


## Installation

```
gem install jekyll-paginate-v2
```

Update your [_config.yml](#site-configuration) and [pages](#page-configuration).

> Although backwards compatible, this gem needs slightly extended [site yml](#site-configuration) configuration and adds miniscule new front-matter for the [paging templates](#page-configuration) configuration elements.

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

All this while being fully backwards compatible with the old [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) gem (requires minimal additional front-matter, see [page-configuration](#page-configuration)).


## Contributing

I currently need testers and people willing to give me feedback and code reviews.

1. Fork it ( https://github.com/sverrirs/jekyll-paginate-v2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Build the gem locally (`gem build jekyll-paginate-v2.gemspec`)
5. Test and verify the gem locally (`gem install ./jekyll-paginate-v2-x.x.x.gem`) 
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

Note: This project uses [semantic versioning](http://semver.org/).

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

  # Optional additional suffix for the title of the paginated pages (the prefix is inherited from the template page)
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

## Page configuration

To enable pagination on a page (i.e. make that page a template for pagination) then simply include the minimal pagination configuration in the page front-matter:

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
<ul class="pager">
    {% if paginator.previous_page %}
    <li class="previous">
        <a href="{{ paginator.previous_page_path | prepend: site.baseurl | replace: '//', '/' }}">Newer Posts</a>
    </li>
    {% endif %}
    {% if paginator.next_page %}
    <li class="next">
        <a href="{{ paginator.next_page_path | prepend: site.baseurl | replace: '//', '/' }}">Older Posts</a>
    </li>
    {% endif %}
</ul>
{% endif %}
```

The code is fully backwards compatible and you will have access to all the normal paginator variables defined in the [official jekyll documentation](https://jekyllrb.com/docs/pagination/#liquid-attributes-available). 

Neat!

## Paginate categories, tags, locales

Enabling pagination for specific categories, tags or locales is as simple as adding values to the pagination template front-matter and corresponding values in the posts.

### Filtering categories

Filter single category 'software'

``` yml
pagination: 
  enabled: true
  category: software
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

All of the configuration elements from the `_config.yml` file can be overwritten in the pagination template pages. E.g. if you want one category page to have different permalink structure simply override the item like so

``` yml
pagination: 
  enabled: true
  category: cars
  permalink: '/cars/:num/'
```

Overriding sorting to sort by the post title in ascending order for another paginated template could be done like so

``` yml
pagination: 
  enabled: true
  category: ruby
  sort_field: 'title'
  sort_reverse: false
```