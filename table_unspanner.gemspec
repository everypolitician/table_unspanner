# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_unspanner/version'

Gem::Specification.new do |spec|
  spec.name          = 'table_unspanner'
  spec.version       = TableUnspanner::VERSION
  spec.authors       = ['Chris Mytton']
  spec.email         = ['chrismytton@gmail.com']

  spec.summary = 'Replace rowspan/colspan attributes in HTML tables with' \
    ' duplicate rows/columns to make scraping easier.'
  spec.homepage = 'https://github.com/everypolitician/table_unspanner'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
