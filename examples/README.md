# Jekyll::Paginate V2::Examples

Here are a few example sites that use the new jekyll-paginate-v2 gem. They can serve as a help and guide on the nitty gritty details of configuring the gem and leveraging its more advanced features.

Please feel free to fork and play around with this code to quickly test out different scenarios and site structures.

All examples are generated from running the `jekyll new .` command and they all use the [default `minima` theme](https://github.com/jekyll/minima).

## Example 1: Typical Blog
Simple blog that only has one type of post pages. The index.html page does the pagination. 

This example also demonstrates how the page can operate as a zero-config replacement for the old [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) gem.

## Example 2: Category Pagination
Car site that has multiple paginated pages and multiple post categories.

## Example 3: Tag and Collection Pagination
Book review site that organizes its content into collections and by tags. Uses the `pretty` permalink structure for the site.

Demonstrates the following:

* how the pagination logic handles paginating across one or more collections at the same time. The pagination can also paginate over all collections. 
* how to sort posts by nested front-matter attributes.
* Autopages configuration and setup




