class CreateFormInstances < ActiveRecord::Migration
#FormInstances associations:
  def self.up
    create_table :form_instances do |t|
#inheritance!!
      t.column :type,                               :integer
#belongs_to polymorphic FormA/FormB/etc
      t.column :form_id,                            :integer
      t.column :form_type,                          :integer
#has_one :doctor
      t.column :doctor_id,                          :integer
#has_one :user, :as => 'author'
      t.column :user_id,                            :integer
#Other attributes
      t.column :status,                             :integer, :default => 1
    end
  end

  def self.down
    drop_table :form_instances
  end
end
