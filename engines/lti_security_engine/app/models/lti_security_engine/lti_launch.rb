module LtiSecurityEngine
  class LtiLaunch < ActiveRecord::Base
    serialize :launch_params, Hash
    belongs_to :security_contract
  end
end