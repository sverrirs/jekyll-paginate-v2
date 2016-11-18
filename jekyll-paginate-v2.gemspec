# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginate-v2/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-paginate-v2"
  spec.version       = Jekyll::PaginateV2::VERSION
  spec.authors       = ["Sverrir Sigmundarson"]
  spec.email         = ["jekyll@sverrirs.com"]
  spec.summary       = %q{Pagination Generator for Jekyll 3}
  spec.homepage      = "https://github.com/sverrirs/jekyll-paginate-v2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end