module LtiSecurityEngine
  class Vendor < ActiveRecord::Base
    has_many :security_contracts
  end
end
