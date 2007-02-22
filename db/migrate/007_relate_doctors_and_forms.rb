class RelateDoctorsAndForms < ActiveRecord::Migration
  def self.up
    create_table :doctors_forms do |t|
      t.column :doctor_id,         :integer
      t.column :form_id,           :integer
    end
  end

  def self.down
    drop_table :doctors_forms
  end
end
