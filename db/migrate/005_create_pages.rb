class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title,    :string
      t.column :body,     :text
      t.column :stub,     :string
    end
  end

  def self.down
    drop_table :pages
  end
end
