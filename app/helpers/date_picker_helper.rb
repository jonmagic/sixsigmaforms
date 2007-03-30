module DatePickerHelper
  def date_picker_field(object, method)
    obj = instance_eval("@#{object}")
    value = obj.send(method)
    display_value = value.respond_to?(:strftime) ? value.strftime('%d %b %Y') : value.to_s
    display_value = '[ choose date ]' if display_value.blank?

    out = hidden_field(object, method)
    out << content_tag('a', display_value, :href => '#',
        :id => "_#{object}_#{method}_link", :class => '_demo_link',
        :onclick => "DatePicker.toggleDatePicker('#{object}_#{method}'); return false;")
    out << tag('div', :class => 'date_picker', :style => 'display: none',
                      :id => "_#{object}_#{method}_calendar")
    if obj.respond_to?(:errors) and obj.errors.on(method) then
      ActionView::Base.field_error_proc.call(out, nil) # What should I pass ?
    else
      out
    end
  end
end
