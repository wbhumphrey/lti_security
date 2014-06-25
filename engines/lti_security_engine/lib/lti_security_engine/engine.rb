module LtiSecurityEngine
  class Engine < ::Rails::Engine
    isolate_namespace LtiSecurityEngine

    require 'ims/lti'
    require 'oauth/request_proxy/rack_request'

    OAUTH_10_SUPPORT = true

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
