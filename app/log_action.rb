class LogAction
  def initialize(inner, log_to: LOGGER)
    @inner  = inner
    @logger = log_to
  end

  def method_missing(m, *args, &block)
    @logger.info("#{@inner.file_path} sent.")
    @inner.send(m)
  end
end
