class ListenToFileModification
  def self.to(path, file_name)
    listener = Listen.to(path, force_polling: true, only: /^LOTTI.DBF$/) do |modified, _added, _removed|
      unless modified.empty?
        yield
      end
    end
    listener.start
    sleep
  end
end
