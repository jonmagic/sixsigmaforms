class FormType < ActiveRecord::Base
  serialize :required_fields, Array
  has_many :form_instances
  has_and_belongs_to_many :doctors

  validates_presence_of :friendly_name, :name

  def self.model_for(name)
    FormType.find_by_name(name).nil? ? nil : name.constantize
  end

  def the_model
    self.name.constantize
  end

end
