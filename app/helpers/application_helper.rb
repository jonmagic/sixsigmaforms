# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

end

class String < Object
  def status_to_number
    num = ['draft', 'submitted', 'reviewed', 'accepted', 'archived'].index(self.downcase)
    num.nil? ? nil : num+1
  end

  def fromCamelCase
    self.to_s.sub(/(.)([A-Z])/, '\1_\2').downcase
  end
end

class Fixnum < Integer
  def number_to_status
    txt = ['draft', 'submitted', 'reviewed', 'accepted', 'archived'][self-1]
  end
end
