class FormType < ActiveRecord::Base
  serialize :required_fields, Array
  has_many :form_instances
  has_and_belongs_to_many :doctors

  validates_presence_of :friendly_name, :form_type, :required_fields

end
