# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "rspec-sql"
  s.version     = "0.0.1"
  s.summary     = "RSpec::Sql matcher"
  s.description = "RSpec matcher for database queries."
  s.authors     = ["Maikel Linke", "Open Food Network contributors"]
  s.email       = "maikel@openfoodnetwork.org.au"
  s.files       = Dir["lib/**/*.rb"]
  s.homepage    = "https://github.com/openfoodfoundation/rspec-sql"
  s.license     = "AGPL-3.0-or-later"
  s.required_ruby_version = ">= 3.1", "< 4"

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "rspec"
  s.metadata["rubygems_mfa_required"] = "true"
end
