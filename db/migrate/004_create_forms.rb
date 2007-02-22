class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.column :friendly_name,        :string
      t.column :alias,                :string #Alias: CMS1500, Model: Cms1500.rb, SQL: cms_1500
      t.column :fields,               :string #YAML array
      t.column :required_fields,      :string #YAML array
      t.column :can_have_notes,       :boolean
    end
  end

  def self.down
    drop_table :forms
  end
end
