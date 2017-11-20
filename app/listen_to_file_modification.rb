class ListenToFileModification
  def self.to(path, on_error: ErrorHandler)
    listener = Listen.to(path, force_polling: true, only: /^LOTTI.DBF$/) do |modified, _added, _removed|
      unless modified.empty?
        yield
      end
    end
    listener.start
    sleep
  rescue Exception => error
    on_error.call(error)
  end
end
