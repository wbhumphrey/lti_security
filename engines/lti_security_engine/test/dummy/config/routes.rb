Rails.application.routes.draw do

  mount LtiSecurityEngine::Engine => "/lti_security_engine"
end
