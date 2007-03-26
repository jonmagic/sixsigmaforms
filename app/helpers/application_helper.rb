# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tab_link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if html_options.kind_of?(Hash) and !html_options[:active_only_if_equal].nil?
      active_only_if_equal = html_options[:active_only_if_equal]
      html_options.delete(:active_only_if_equal)
    else
      active_only_if_equal = false
    end
    url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
    html_options ||= {}
    html_options[:class] = html_options[:class].blank? ? 'active' : html_options[:class] + ' active' if (active_only_if_equal ? request.request_uri == url : request.request_uri =~ /^#{url}/)
    link_to(name, options, html_options, *parameters_for_method_reference)
  end

end

class String < Object
  def as_status
    Status.new(self)
  end

  def fromCamelCase
    self.to_s.sub(/(.)([A-Z])/, '\1_\2').downcase
  end
end

class Fixnum < Integer
  def as_status
    Status.new(self)
  end
end

class Array < Object
  def count
    self.length
  end
end