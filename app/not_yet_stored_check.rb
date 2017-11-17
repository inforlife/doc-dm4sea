class NotYetStoredCheck
  def self.call(cgmp_batch)
    DatabaseRecord.where(batch: cgmp_batch.batch).empty?
  end
end
