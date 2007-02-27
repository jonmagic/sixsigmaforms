class CreateIndexPage < ActiveRecord::Migration
  def self.up
    execute 'INSERT INTO pages(title, stub, body) VALUES("SixSigma: Index", "index", "<h1>This is the Index Page!</h1>\n<p>Put whatever you want in here!</p><p>Oh, and try the Services link to see the services page.</p>")'
  end

  def self.down
    execute 'DELETE FROM pages WHERE stub="index"'
  end
end
