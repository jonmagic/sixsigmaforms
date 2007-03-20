class LogsController < ApplicationController

  def history
    @logs = Log.find(:all, :order => :created_at, :limit => 50)
  end
end
