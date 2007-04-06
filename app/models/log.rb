class Log < ActiveRecord::Base
  serialize :data
  belongs_to :object, :polymorphic => true
  belongs_to :agent,  :polymorphic => true

  def self.readable_logs_for_FormInstances(logs)
    log_strings = []
    for log in logs do
      log_strings.push "#{log.created_at.strftime('%b %d, %Y at %I:%M%p')}: " +
      case log.log_type
        when 'update:Forminstance'
          if log.data[:old_attributes].has_key?('status_number')
            case
              when log.data[:old_attributes]['status_number']==1 && log.data[:new_attributes]['status_number']==2
                "#{log.agent.friendly_name} submitted the form to SixSigma."
              when log.data[:old_attributes]['status_number']==2 && log.data[:new_attributes]['status_number']==3
                "#{log.agent.friendly_name} is reviewing the form."
              when log.data[:old_attributes]['status_number']==2 && log.data[:new_attributes]['status_number']==1
                "#{log.agent.friendly_name} sent form BACK to #{log.object.doctor.friendly_name}."
            end
          else
            "Form Instance Updated by #{log.agent.friendly_name}: changed (#{log.data[:old_attributes].keys.join(', ')}) from (#{log.data[:old_attributes].values.join(', ')}) to (#{log.data[:new_attributes].values.join(', ')})."
          end
        when /update:/
          "Updated by #{log.agent.friendly_name}: changed (" + log.data[:old_attributes].reject {|k,v| k=='status_number' || k=='has_been_submitted'}.keys.join(', ') + ") from (" + log.data[:old_attributes].reject {|k,v| k=='status_number' || k=='has_been_submitted'}.values.join(', ') + ") to (" + log.data[:new_attributes].reject {|k,v| k=='status_number' || k=='has_been_submitted'}.values.join(', ') + ")."
        else
          "#{log.log_type} -- #{log.data.to_yaml}"
      end.to_s
    end
    log_strings
  end
  
end
