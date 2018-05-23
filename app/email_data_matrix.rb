class EmailDataMatrix
  def self.for_batch_records_printed_today
    records  = CGMPRecord.new('LOTTI').where(stato: '0', prt_fdl: true)

    records.each do |cgmp_record|
      if BagCheck.call(cgmp_record) && NotYetStoredCheck.call(cgmp_record)
        generate_and_email_datamatrix_for(cgmp_record)
        DatabaseRecord.new(batch: cgmp_record.batch, fdl: true).save
      end
    end
  end

  def self.for_batch(batch_code)
    batch = CGMPRecord.new('LOTTI').first(batch: batch_code)
    generate_and_email_datamatrix_for(batch)

    record = DatabaseRecord.where(batch: batch_code).first
    record.update(fdl: true)
  end

private

  def self.generate_and_email_datamatrix_for(batch)
    LogAction.new(EmailFile.new(DataMatrixPdf.new(VariableData.new(batch)).save)).deliver
  end
end
