class CreateFormInstances < ActiveRecord::Migration
  def self.up
    create_table :form_instances do |t|
      t.column :doctor_id,                          :integer
      t.column :type,                               :integer
      t.column :form_id,                            :integer
      t.column :user_id,                            :integer
      t.column :status,                             :integer, :default => 1
    end
  end

  def self.down
    drop_table :form_instances
  end
end
