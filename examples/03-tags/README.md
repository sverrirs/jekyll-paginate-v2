# Example 03::Tag pagination

This example bookshop website expands on the category example and adds pagination by both category and tags. The site uses the pretty permalink structure. It also demonstrates advanced sorting features such as nested fields. 

<p align="center">
  <img src="https://raw.githubusercontent.com/sverrirs/jekyll-paginate-v2/master/examples/img/03-example-screenshot-main.png" />
</p>

The site is generated using the jekyll built in new command `jekyll new myblog` and it uses the [default `minima` theme](https://github.com/jekyll/minima).

After generating the pagination gem was installed using
```
gem install jekyll-paginate-v2
```

## Structure

The site has four types of post categories `biography/_posts`, `blog/_posts`, `fantasy/_posts`, `romance/_posts`. 

All book posts have assigned multiple tags to them.

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

### byisbn.md 
Demonstrates how to have multiple pagination pages defined in the root of the site without their pagination pages clashing. Uses permalinks to achieve this.

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
