$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lti_security_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lti_security_engine"
  s.version     = LtiSecurityEngine::VERSION
  s.authors     = ["Brad Humphrey"]
  s.email       = ["brad@instructure.com"]
  s.homepage    = "https://github.com/wbhumphrey/lti_security"
  s.summary     = "App for externally managing lti security"
  s.description = "Allows other apps to authenticate via LTI with a simple gem"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.5"
  s.add_dependency "ims-lti"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3"
end
