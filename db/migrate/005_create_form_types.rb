class CreateFormTypes < ActiveRecord::Migration
  def self.up
    create_table :form_types do |t|
      t.column :friendly_name,        :string
      t.column :name,                 :string #Type: CMS1500, Model: Cms1500.rb, SQL: cms_1500
      t.column :can_have_notes,       :boolean
    end
  end

  def self.down
    drop_table :form_types
  end
end
