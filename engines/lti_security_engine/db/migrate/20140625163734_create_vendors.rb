class CreateVendors < ActiveRecord::Migration
  def change
    create_table :lti_security_engine_vendors do |t|
      t.string :code
      t.string :vendor_name
      t.text   :description
      t.string :website
      t.string :email
    end
  end
end
