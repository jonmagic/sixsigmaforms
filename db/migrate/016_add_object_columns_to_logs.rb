class AddObjectColumnsToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :object_id,    :integer
    add_column :logs, :object_type,  :integer
    add_column :form_instances, :submitted, :boolean
  end

  def self.down
    remove_column :logs, :object_id
    remove_column :logs, :object_type
    remove_column :form_instances, :submitted
  end
end
