source 'https://rubygems.org'

# Specify your gem's dependencies in jekyll-paginate-v2.gemspec
gemspec

gem "jekyll", "~> #{ENV["JEKYLL_VERSION"]}" if ENV["JEKYLL_VERSION"]

# adding dev-dependencies to Gemfile (instead of gemspec) allows calling
# `bundle exec [executable] [options]` more easily.
group :test do
  gem "rubocop", "~> 0.51.0"
end
