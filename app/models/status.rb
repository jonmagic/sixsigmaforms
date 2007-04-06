class Status
  attr_accessor :number

  def initialize(status)
    if status.kind_of? Fixnum
      self.number = status
    elsif status.kind_of? String
      self.number = text_to_number(status)
    elsif status.kind_of? Status
      self.number = status.number
    end
  end

  def inspect
    self.text
  end
  def text
    self.word('lowercase short singular')
  end

  def next
    Status.new(self.number + 1)
  end
  def prev
    Status.new(self.number - 1)
  end
  def next!
    self.number += 1
    self
  end
  def prev!
    self.number -= 1
    self
  end

  def word(options)
    case options
      when 'lowercase short singular'
        return ['all', 'draft', 'submitted', 'reviewing', 'archived'][self.number]
      when 'lowercase short plural'
        return ['all', 'drafts', 'submitted', 'reviewing', 'archived'][self.number]
      when 'lowercase long singular'
        return ['all', 'draft', 'submitted form', 'forms in review', 'archived form'][self.number]
      when 'lowercase long plural'
        return ['all forms', 'drafts', 'submitted forms', 'forms in review', 'archived forms'][self.number]
      when 'uppercase short singular'
        return ['All', 'Draft', 'Submitted', 'In Review', 'Archived'][self.number]
      when 'uppercase short plural'
        return ['All', 'Drafts', 'Submitted', 'In Review', 'Archived'][self.number]
      when 'uppercase long singular'
        return ['All', 'Draft', 'Submitted Form', 'Forms In Review', 'Archived Form'][self.number]
      when 'uppercase long plural'
        return ['All Forms', 'Drafts', 'Submitted Forms', 'Forms In Review', 'Archived Forms'][self.number]
    end
  end

  private
    def text_to_number(text)
      ['all', 'draft', 'submitted', 'reviewing', 'archived'].index(text)
    end
end