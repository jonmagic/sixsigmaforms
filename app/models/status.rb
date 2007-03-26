class Status
  attr_accessor :status_number

  def initialize(status)
    if status.kind_of? Fixnum
      self.status_number = status
    elsif status.kind_of? String
      self.status_number = text_to_number(status)
    end
  end

  def number
    self.status_number
  end
  def text
    self.word('lowercase short singular')
  end

  def word(options)
    case options
      when 'lowercase short singular'
        return ['draft', 'submitted', 'reviewed', 'archived'][self.status_number]
      when 'lowercase short plural'
        return ['drafts', 'submitted', 'reviewed', 'archived', 'all'][self.status_number]
      when 'lowercase long singular'
        return ['draft', 'submitted form', 'reviewed form', 'archived form'][self.status_number]
      when 'lowercase long plural'
        return ['drafts', 'submitted forms', 'reviewed forms', 'archived forms', 'all forms'][self.status_number]
      when 'uppercase short singular'
        return ['Draft', 'Submitted', 'Reviewed', 'Archived'][self.status_number]
      when 'uppercase short plural'
        return ['Drafts', 'Submitted', 'Reviewed', 'Archived', 'All'][self.status_number]
      when 'uppercase long singular'
        return ['Draft', 'Submitted Form', 'Reviewed Form', 'Archived Form'][self.status_number]
      when 'uppercase long plural'
        return ['Drafts', 'Submitted Forms', 'Reviewed Forms', 'Archived Forms', 'All Forms'][self.status_number]
    end
  end

  private
    def text_to_number(text)
      ['draft', 'submitted', 'reviewed', 'archived', 'all'].index(text)
    end
end