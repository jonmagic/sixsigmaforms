class Log < ActiveRecord::Base
  serialize :data
  belongs_to :object, :polymorphic => true
  belongs_to :agent,  :polymorphic => true

end
