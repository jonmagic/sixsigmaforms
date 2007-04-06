class Note < ActiveRecord::Base
  belongs_to :form_instance
  belongs_to :author, :polymorphic => true

end
