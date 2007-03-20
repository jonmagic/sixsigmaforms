class Log < ActiveRecord::Base
  serialize :data
  before_create :add_timestamp
  
  private
    def add_timestamp
      self.created_at = Time.now
    end
end
