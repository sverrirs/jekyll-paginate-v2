---
layout: post
title:  "Welcome to Jekyll Paginate V2!"
date:   2016-10-27 19:16:49 +0100
tags: welcome, jekyll, blog, fun
---
You’ll find this post in your `_posts` directory. This post along with all of the other example posts is paginated by the new [jekyll-paginate-v2 gem](https://github.com/sverrirs/jekyll-paginate-v2).

This pagination gem is built specially for Jekyll 3 and newer and is intended to replace the now discontinuted jekyll-paginate gem. 

This v2 of the gem offers full backwards compatibility with the old gem and its site configuration. You can simply replace the old jekyll-paginate gem with this one and your sites will still work without any changes.

However to access the new enhanced features of this gem, like pagination on categories, tags and locales, then you need to remove the old jekyll-paginate configuration and activate the new `pagination:` [site configuration](https://github.com/sverrirs/jekyll-paginate-v2#site-configuration). 

The [source code](https://github.com/sverrirs/jekyll-paginate-v2/tree/master/examples) for this example project will show you all the necessary steps.

## Installing

Go ahead and install the latest version of the gem from [rubygems.org](https://rubygems.org/gems/jekyll-paginate-v2)

```
gem install jekyll-paginate-v2
```

Replace the `jekyll-paginate` gem with `jekyll-paginate-v2` in both your `_config.yml` and your `Gemfile`.

Now go ahead and re-build your site to start running the new pagination logic. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

Please see the [GitHub repo](https://github.com/sverrirs/jekyll-paginate-v2) to learn how to get the most out of this new pagination gem. There we also discuss the gems more advanced features. 

Please file all bugs/feature requests in the issues section of the [GitHub repo](https://github.com/sverrirs/jekyll-paginate-v2/issues).

Have a great day :)
