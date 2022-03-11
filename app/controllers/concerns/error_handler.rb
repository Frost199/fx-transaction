module ErrorHandler
  extend ActiveSupport::Concern

  ERRORS = {
    'ActiveRecord::RecordNotFound' => 'CustomErrors::NotFound',
    'ActiveRecord::RecordInvalid' => 'CustomErrors::Invalid'
  }.freeze

  included do
    rescue_from(StandardError, with: ->(e) { handle_error(e) })
  end

  private

  def handle_error(e)
    mapped = map_error(e)
    # notify about unexpected_error unless mapped
    mapped ||= CustomErrors::StandardError.new
    render_error(mapped)
  end

  def map_error(error)
    return if error.nil?

    error_klass = error.class.name
    return error if ERRORS.values.include?(error_klass)

    return if ERRORS[error_klass].nil?

    ERRORS[error_klass].constantize&.new
  end

  def render_error(error)
    render json: ErrorSerializer.new(error), status: error.status
  end
end
