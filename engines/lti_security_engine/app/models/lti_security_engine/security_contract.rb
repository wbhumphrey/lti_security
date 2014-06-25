module LtiSecurityEngine
  class SecurityContract < ActiveRecord::Base
    belongs_to :vendor
    has_many :lti_launches
  end
end