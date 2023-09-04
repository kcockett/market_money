class ErrorSerializer
  
  def self.serialize(errors)
    if errors.is_a?(String)
      {
        errors: [
          {
            detail: errors
          }
        ]
      }
    else
      if errors.is_a?(Array)
        full_messages = errors.join(', ')
      else
        full_messages = errors.full_messages.join(', ')
      end
      
      {
        errors: [
          {
            detail: "Validation failed, #{full_messages}"
          }
        ]
      }
    end
  end
end
