class CreateFormInstances < ActiveRecord::Migration
#FormInstances associations:
  def self.up
    create_table :form_instances do |t|
#belongs_to form_type
      t.column :form_type_id,                     :integer
#belongs_to polymorphic FormA/FormB/etc
      t.column :form_data_id,                     :integer
      t.column :form_data_type,                   :string
#has_one :doctor
      t.column :doctor_id,                        :integer
#has_one :patient
      t.column :patient_id,                       :integer
#has_one :user
      t.column :user_id,                          :integer #effectively 'created_by'
#Other attributes
      t.column :status_number,                    :integer, :default => 1
      t.column :created_at,                       :datetime
    end
  end

  def self.down
    drop_table :form_instances
  end
end
