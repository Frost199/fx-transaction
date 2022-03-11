module CustomErrors
  class NotFound < CustomErrors::StandardError
    def initialize(url_path: nil)
      super(
        title: 'Record not Found',
        status: 404,
        detail: 'We could not find the object you were looking for.',
        source: { pointer: '/request/url/:id' }
      )
      @url_path = url_path
    end

    def serializable_hash
      {
        status: status,
        title: title,
        detail: 'We could not find the object you were looking for.',
        source: { pointer: url_path }
      }
    end

    private

    attr_reader :url_path
  end
end
