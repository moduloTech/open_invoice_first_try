# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'open_invoice/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'open_invoice'
  spec.version     = OpenInvoice::VERSION
  spec.authors     = ['Mikhail Varabyou']
  spec.email       = ['varaby_m@modulotech.fr']
  spec.homepage    = 'https://open-invoice.io'
  spec.summary     = 'Summary of OpenInvoice.'
  spec.description = 'Description of OpenInvoice.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.0'

  spec.add_dependency 'pg', '~> 1.1'

  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-rails', '~> 2.3'
end
