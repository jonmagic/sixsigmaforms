class FormInstance < ActiveRecord::Base
  has_many :notes
  belongs_to :doctor
  belongs_to :form_type  # form_type_id
  belongs_to :form_data, :polymorphic => true, :as => :form  #form_type, form_id
  
end
