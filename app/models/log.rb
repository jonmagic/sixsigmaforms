class Log < ActiveRecord::Base
  serialize :data
  belongs_to :object, :polymorphic => true
end
