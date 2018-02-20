class EmailDataMatrix
  def self.after_batch_record_print
    last_batch = CGMPRecord.new('LOTTI').last

    if NewProductionOrderCheck.call(last_batch) && BagCheck.call(last_batch) && NotYetStoredCheck.call(last_batch)
      DatabaseRecord.new(batch: last_batch.batch, fdl: false).save
    else
      DatabaseRecord.where(fdl: false).each do |record|
        # CGMPRecord.new('LOTTI').first(batch: record.batch) MAY RETURN NIL IF RECORD DELATED IN CGMP
        if CGMPRecord.new('LOTTI').first(batch: record.batch).prt_fdl
          generate_and_email_datamatrix_for(last_batch)
          record.update(fdl: true)
          break
        end
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
