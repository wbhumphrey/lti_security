class CreateSecurityContracts < ActiveRecord::Migration
  def change
    create_table :lti_security_engine_security_contracts do |t|
      t.integer :vendor_id
      t.string :key
      t.string :shared_secret
    end
  end
end
