# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginate-v2/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-paginate-v2"
  spec.version       = Jekyll::PaginateV2::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.date          = '2016-11-19'
  spec.authors       = ["Sverrir Sigmundarson"]
  spec.email         = ["jekyll@sverrirs.com"]
  spec.homepage      = "https://github.com/sverrirs/jekyll-paginate-v2"
  spec.license       = "MIT"

  spec.summary       = %q{Pagination Generator for Jekyll 3}
  spec.description   = %q{An enhanced in-place replacement for the previously built-in jekyll-paginate gem offering full backwards compatability as well as a slew of new frequently requested features}
  
  spec.files         = `git ls-files -z`.split("\x0")
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end