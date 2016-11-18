# Jekyll::Paginate V2

Pagination plugin built specially for Jekyll 3 and newer.

Enhanced replacement for the previously built-in [jekyll-paginate gem](https://github.com/jekyll/jekyll-paginate).

The code was based on the original design of [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) and features were mostly drawn from discussions from the issues pages (especially https://github.com/jekyll/jekyll-paginate/issues/27) and some from the excellent [Octopress::Paginate code](https://github.com/octopress/paginate). 

Thanks everybody :heart:

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

All this while being fully backwards compatible with the pld [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) gem!

## Installation

Currently this plugin is in develpment mode and is not yet distributed as a gem (mostly because I don't know how).

To install, simply copy the `lib\jekyll-paginate-v2.rb` file into the `_plugins` folder under your Jekyll site root. 
> If the _plugins folder does not exist simply create it.

Then add the necessary [Site YML](#site-configuration) and [Page](#page-configuration) configuration elements.

Run `jekyll serve` and you should see the pagination plugin debug messages printed during site generation:

``` bash
  Generating...
    Pagination: found template: pictures/bestof.md
    Pagination: found template: puffins/list.html
    Pagination: found template: index.html
```

## Current state

Currently this code is in dire need of feedback, code review and testing.

I also would welcome guidance on how to write automated tests for this code so that I can publish it as a Gem.

Come to think of it, I currently have no idea on how to publish a Gem... :/

> Don't worry too much about the current structure, this is just the first iteration.
> The code is currently a single file `jekyll-paginate-v2.rb` only because it makes it faster to develop and debug. As soon as I and hopefully other people test and green-light the logic I intend to break this code into separate files and distribute as a gem.  

## Contributing

1. Fork it ( https://github.com/sverrirs/jekyll-paginate-v2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

  # Limit how many content objects to paginate (default: 0, means all)
  limit: 0
  
  # Optional, defines the field that the posts should be sorted on (omit to default to 'date')
  sort_field: 'title'

  # Optional, sorts the posts in reverse order (omit to default decending or sort_reverse: true)
  sort_reverse: true

  # The default category to use, just leave this as 'posts' to get a backwards-compatible behavior (all posts)
  category: 'posts'

  # Optional, the default tag to use, omit to disabled
  tag: 'cool'

  # Optional, the default locale to use, omit to disable (depends on a field 'locale' to be specified in the posts, 
  # in reality this can be any value, suggested are the Microsoft locale-codes (e.g. en_US, en_GB) or simply the ISO-639 language code )
  locale: 'en_US' 

############################################################
```

## Page configuration

To enable pagination on a page (i.e. make that page a template for pagination) then simply include the minimal pagination configuration in the page front-matter:

``` yml
pagination: 
  enabled: true
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

## Paginate on conbination of filters

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
