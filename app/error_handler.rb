class ErrorHandler
  def self.call(error)
    Rollbar.error(error)
  end
end
