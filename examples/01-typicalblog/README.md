# Example 01::Typical Blog
This example site shows how the pagination gem can be used on a simple blog site. 

<p align="center">
  <img src="https://raw.githubusercontent.com/sverrirs/jekyll-paginate-v2/master/examples/img/01-example-screenshot-main.png" />
</p>

The site is generated using the jekyll built in new command `jekyll new myblog` and it uses the [default `minima` theme](https://github.com/jekyll/minima).

After generating the pagination gem was installed using

```
gem install jekyll-paginate-v2
```

## Structure
The blog has only one type of posts, blog posts. No category pagination is performed. To implement the pagination for the minima theme the `_layouts/home.html` needed to be modified to call the pagination logic.

The `_includes/header.html` was also overridden to omit listing the auto-generated pagination sites at the top of the header part.

## Setup configuration

The gem is added to the `_config.yml` file under
``` yml
gems:
  - jekyll-paginate-v2
```

as well as to the `Gemfile` into the main loop
``` ruby
group :jekyll_plugins do
  gem "jekyll-paginate-v2"
  gem "jekyll-feed"
end
```

At this point is is advisable to delete the `Gemfile.lock` file to clear out any potential issues with gem caching and dependency issues (no worries this file will be auto generated for you again).

## Configuring the pagination

Add the pagination configuration to `_config.yml`

``` yml
# Pagination Settings
pagination:
  enabled: true
  per_page: 3
  permalink: '/page/:num/'
  title: ' - page :num'
  limit: 0
  sort_field: 'date'
  sort_reverse: true
```


Due to the way the entries in the blog utilize multiple categories it is also good to explicitly state the permalink format to avoid excessive nesting of the post pages. So place the following line into the `_config.yml` file as well

``` yml
# Produces a cleaner folder structure when using categories
permalink: /:year/:month/:title.html
```

## Completing the setup
Now the pagination simply needs to be enabled in the `index.html` file.

``` yml
---
layout: home
pagination: 
  enabled: true
---
```

That is it, no further configuration is needed!

Try building the site yourself using `jekyll build` or `jekyll serve`.

## Testing backwards compatability

In the `_config.yml` file remove or comment out the new `pagination:` configuration and paste/uncomment the following configuration instead. 

``` yml
# Old jekyll-paginate pagination logic
paginate: 3
paginate_path: "/legacy/page:num/"
```
Now run `jekyll serve` again and the gem will generate the pagination according to the old jekyll-paginate rules and behavior.

> You must disable the new pagination configuration for the old one to work. You cannot run both configurations at the same time.

Cheers :heart:
