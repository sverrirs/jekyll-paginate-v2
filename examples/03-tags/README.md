# Example 03::Tag and Collection pagination

This example bookshop website uses collections to organize its books^*. The site relies on pagination of its books by both collections and tags. The site shows how to paginate by single, multiple or all collections at the same time. 

The site uses the pretty permalink structure. It also demonstrates advanced sorting features such as nested fields. 

<p align="center">
  <img src="https://raw.githubusercontent.com/sverrirs/jekyll-paginate-v2/master/examples/img/03-example-screenshot-main.png" />
</p>

The site is generated using the jekyll built in new command `jekyll new myblog` and it uses the [default `minima` theme](https://github.com/jekyll/minima).

After generating the pagination gem was installed using
```
gem install jekyll-paginate-v2
```

^* _It could be argued that the bookstore should have just used categories here and collections were better suited to separate things into 'books', 'DVDs', 'Games' etc..._

## Structure

The site has three types of document collections `_biography/`, `_fantasy/`, `_romance/`. In addition to that the bookstore also has a blog and those posts are stored under `blog/_posts`. 

All books have multiple tags assigned to them.

Permalinks are configured to the `pretty` format site-wide. The pagination logic handles this configuration without problems and constructs the correct sub url structure.

Pagination pages are:

* biography/biograpy.md
* biography/biograpy-musicians.md
* romance/romance-historical.md
* tags/contemporary.md
* tags/fantasy.md
* tags/sci-fi.md
* index.md
* byisbn.md

Most pages are self explanatory and most sort books by the nested attribute `rank`.

### Page: byisbn.md 
Demonstrates how to have multiple pagination pages defined in the root of the site without their pagination pages clashing. Uses permalinks to achieve this.

### Page: Under tags/
Demonstrate how to paginate across multiple collections by using the `collections: all` front matter configuration

## Setup Configuration
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


Try building the site yourself using `jekyll build` or `jekyll serve`.

Cheers :heart:
