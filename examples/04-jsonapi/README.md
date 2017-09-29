# Example 04::Dynamic JSON/AJAX API
This example site shows how the pagination gem can be used to generate JSON feed files that can be used to provide dynamically loaded content to your website using Javascript and AJAX/XHR calls.

The site is generated using the jekyll built in new command `jekyll new myblog` and it uses the [default `minima` theme](https://github.com/jekyll/minima).

After generating the pagination gem was installed using

```
gem install jekyll-paginate-v2
```

## Structure

The site contains a single index.html file and a few example posts. The index.html is responsible for generating the json feed files that contain information about the post content on the website.

Below is an example content from one of the generated json files:

```
{
  "pages": [
    {
      "title": "Narcisse Snake Pits",
      "link": "/2016/11/narcisse-snake-pits.html"
    },{
      "title": "Luft-Fahrzeug-Gesellschaft",
      "link": "/2016/11/luft-fahrzeug-gesellschaft.html"
    },{
      "title": "Rotary engine",
      "link": "/2016/11/rotary-engine.html"
    }
  ], 
  "next": "/api/feed-3.json",
  "prev": "/api/feed-1.json"
}
```

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

The normal pagination for the site can be added to the  `_config.yml` file as normal. 
However it is advisable to configure the feed generating pages independantly of the main site pagination configuration.

Therefore the `index.html` page contains the following frontmatter:


``` yml
---
layout: null
permalink: /api
pagination:
  permalink: 'feed-:num'
  enabled: true
  extension: json
  indexpage: 'feed-1'
---
```

## Completing the setup
Now you need to configure the generation of the JSON contents for your paginated files. Do this by specifying the following code in the body of the `index.html` page

``` yml
{
  "pages": [{% for post in paginator.posts %}
    {% if forloop.first != true %},{% endif %}
    {
      "title": "{{ post.title }}",
      "link": "{{ post.url }}"
    }{% endfor %}
  ], 
  {% if paginator.next_page %}
  ,"next": "{{ paginator.next_page_path }}"
  {% endif %}
  {% if paginator.previous_page %}
  ,"prev": "{{ paginator.previous_page_path }}"
  {% endif %}
}
```

That is it, no further configuration is needed!

Try building the site yourself using `jekyll build` or `jekyll serve`.

Cheers :heart:
