class Note < ActiveRecord::Base
  belongs_to :form_instance, :polymorphic => true
  
end
