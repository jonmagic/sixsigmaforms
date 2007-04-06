class AddSubmittedToFormInstances < ActiveRecord::Migration
  def self.up
    add_column :form_instances, :has_been_submitted,    :boolean, :default => 0
    FormInstance.find(:all).each do |form|
      if form.status_number > 1
        form.has_been_submitted = true
        form.save
      end
    end
  end

  def self.down
    remove_column :form_instances, :has_been_submitted
  end
end
