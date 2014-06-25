class CreateLtiLaunches < ActiveRecord::Migration
  def change
    create_table :lti_security_engine_lti_launches do |t|
      t.integer :security_contract_id
      t.string :nonce
      t.text :launch_params
      t.timestamps
    end
  end
end
