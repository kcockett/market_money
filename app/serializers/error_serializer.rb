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
      full_messages = errors.full_messages.join(', ')
      {
        errors: [
          {
            detail: "Validation failed: #{full_messages}"
          }
        ]
      }
    end
  end

  def self.not_found(entity, id)
    serialize("Could not find #{entity} with 'id'=#{id}")
  end
end
