def build_observer(klass, name, options = {})
  if options[:with] && !options[:with].include?("=")
    options[:with] = "'#{options[:with]}=' + value"
  else
    options[:with] ||= 'value' if options[:update]
  end

  callback = options[:function] || remote_function(options)
  javascript = options[:assigns] + " = " if options[:assigns]
  javascript = '(' unless options[:assigns]
  javascript << "new #{klass}('#{name}', "
  javascript << "#{options[:frequency]}, " if options[:frequency]
  javascript << "function(element, value) {"
  javascript << "#{callback}}"
  javascript << ", '#{options[:on]}'" if options[:on]
  javascript << "); " + options[:assigns] + ".lastValue = ''" if options[:assigns]
  javascript << ")).lastValue = '';" unless options[:assigns]
  javascript_tag(javascript)
end
