class AddSharedSecretToVendors < ActiveRecord::Migration
  def change
    add_column :lti_security_engine_vendors, :shared_secret, :string
  end
end
