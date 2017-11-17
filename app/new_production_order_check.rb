class NewProductionOrderCheck
  def self.call(cgmp_batch)
    cgmp_batch.stato == '0'
  end
end
