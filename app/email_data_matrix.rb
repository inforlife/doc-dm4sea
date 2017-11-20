class EmailDataMatrix
  def self.after_batch_record_print
    last_batch = CGMPRecord.new('LOTTI').last

    if NewProductionOrderCheck.call(last_batch) && NotYetStoredCheck.call(last_batch)
      DatabaseRecord.new(batch: last_batch.batch, fdl: false).save
    else
      DatabaseRecord.where(fdl: false).each do |record|
        # CGMPRecord.new('LOTTI').first(batch: record.code) MAY RETURN NIL IF RECORD DELATED IN CGMP
        if CGMPRecord.new('LOTTI').first(batch: record.code).prt_fdl
          LogAction.new(EmailFile.new(DataMatrixPdf.new(VariableData.new(last_batch)).save)).deliver
          record.update(fdl: true)
          break
        end
      end
    end
  end
end
