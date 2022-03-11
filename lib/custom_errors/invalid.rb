module CustomErrors
  class Invalid < CustomErrors::StandardError
    def initialize(errors: {})
      @errors = errors
      @status = 422
      @title = 'Unprocessable Entity'
    end

    def serializable_hash
      errors.reduce([]) do |r, (att, msg)|
        r << {
          status: status,
          title: title,
          detail: msg[0],
          source: { pointer: att.to_s }
        }
      end
    end

    private

    attr_reader :errors
  end
end
