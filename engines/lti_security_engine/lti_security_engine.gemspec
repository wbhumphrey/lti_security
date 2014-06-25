$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lti_security_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lti_security_engine"
  s.version     = LtiSecurityEngine::VERSION
  s.authors     = ["Brad Humphrey"]
  s.email       = ["brad@instructure.com"]
  s.homepage    = ""
  s.summary     = "TODO: Summary of LtiSecurityEngine."
  s.description = "TODO: Description of LtiSecurityEngine."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.5"

  s.add_development_dependency "sqlite3"
end
