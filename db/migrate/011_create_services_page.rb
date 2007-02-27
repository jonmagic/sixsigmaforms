class CreateServicesPage < ActiveRecord::Migration
  def self.up
    execute 'INSERT INTO pages(title, stub, body) VALUES("SixSigma: Services", "services", "<p><strong>SixSigma</strong> has a variety of services your business can benefit from.</p>\n<p>One of them is being created before your very eyes.</p>")'
  end

  def self.down
    execute 'DELETE FROM pages WHERE stub="services"'
  end
end
