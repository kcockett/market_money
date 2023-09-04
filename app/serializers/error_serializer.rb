class ErrorSerializer
  
  def self.serialize(errors)
    # if errors.is_a?(String)
      {
        errors: [
          {
            detail: errors
          }
        ]
      }
  end
end
