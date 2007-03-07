class FormType < ActiveRecord::Base
  serialize :fields, Array
  serialize :required_fields, Array
  has_and_belongs_to_many :doctors
  has_many :form_instances

  validates_presence_of :friendly_name, :form_type, :required_fields

#In each form instance, include thes lines
#  has_many :notes, :as => 'form_instance'
#  include FormOperations

end
