class RelateDoctorsAndFormTypes < ActiveRecord::Migration
  def self.up
    create_table :doctors_form_types, :id => false do |t|
      t.column :doctor_id,         :integer
      t.column :form_type_id,      :integer
    end
  end

  def self.down
    drop_table :doctors_form_types
  end
end
