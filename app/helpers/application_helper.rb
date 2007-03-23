# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tab_link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
    html_options ||= {}
    html_options[:class] = 'active' if url == request.request_uri
    link_to(name, options, html_options, parameters_for_method_reference)
  end

end

class String < Object
  def status_to_number
    num = ['draft', 'submitted', 'reviewed', 'accepted', 'archived', 'all'].index(self.downcase)
    num.nil? ? nil : num+1
  end

  def fromCamelCase
    self.to_s.sub(/(.)([A-Z])/, '\1_\2').downcase
  end
end

class Fixnum < Integer
  def number_to_status
    txt = ['draft', 'submitted', 'reviewed', 'accepted', 'archived', 'all'][self-1]
  end
end

class Array < Object
  def count
    self.length
  end
end