# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'open_invoice/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'open_invoice'
  spec.version     = OpenInvoice::VERSION
  spec.authors     = ['moduloTech']
  spec.email       = ['philib_j@modulotech.fr']
  spec.homepage    = 'https://open-invoice.io'
  spec.summary     = 'OpenInvoice Rails engine provides easy way to manage invoices.'
  spec.description = 'Description of OpenInvoice.'
  spec.license     = 'MIT'

  spec.files = Dir[
    'app/**/*',
    'config/routes.rb', 'config/open_invoice.yml', 'config/locales/**/*.yml',
    'lib/open_invoice.rb', 'lib/tasks/**/*.rake', 'lib/open_invoice/**/*.rb',
    'MIT-LICENSE', 'Rakefile', 'README.md', 'package.json', 'yarn.lock', 'r.sh'
  ]

  spec.add_dependency 'rails', '~> 6.0'

  spec.add_dependency 'carrierwave-aws'
  spec.add_dependency 'jbuilder', '~> 2.9'
  spec.add_dependency 'orm_adapter', '~> 0.5.0'
end
