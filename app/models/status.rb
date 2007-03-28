class Status
  attr_accessor :status_number

  def initialize(status)
    if status.kind_of? Fixnum
      self.status_number = status-1
    elsif status.kind_of? String
      self.status_number = text_to_number(status)-1
    end
  end

  def number
    self.status_number+1
  end
  def text
    self.word('lowercase short singular')
  end

  def word(options)
    case options
      when 'lowercase short singular'
        return ['draft', 'submitted', 'reviewing', 'archived'][self.status_number]
      when 'lowercase short plural'
        return ['drafts', 'submitted', 'reviewing', 'archived', 'all'][self.status_number]
      when 'lowercase long singular'
        return ['draft', 'submitted form', 'forms in review', 'archived form'][self.status_number]
      when 'lowercase long plural'
        return ['drafts', 'submitted forms', 'forms in review', 'archived forms', 'all forms'][self.status_number]
      when 'uppercase short singular'
        return ['Draft', 'Submitted', 'In Review', 'Archived'][self.status_number]
      when 'uppercase short plural'
        return ['Drafts', 'Submitted', 'In Review', 'Archived', 'All'][self.status_number]
      when 'uppercase long singular'
        return ['Draft', 'Submitted Form', 'Forms In Review', 'Archived Form'][self.status_number]
      when 'uppercase long plural'
        return ['Drafts', 'Submitted Forms', 'Forms In Review', 'Archived Forms', 'All Forms'][self.status_number]
    end
  end

  private
    def text_to_number(text)
      ['draft', 'submitted', 'reviewing', 'archived', 'all'].index(text)+1
    end
end