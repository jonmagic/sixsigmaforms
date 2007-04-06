class AddAgentToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :agent_id,      :integer
    add_column :logs, :agent_type,    :string
  end

  def self.down
    remove_column :logs, :agent_id
    remove_column :logs, :agent_type
  end
end
