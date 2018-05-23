class VariableData
  def initialize(cgmp_batch)
    @attributes = [ { name: 'product_code',       ai: 93, value: cgmp_batch.codeprod },
                    { name: 'batch_code',         ai: 10, value: cgmp_batch.batch },
                    { name: 'manufacturing_date', ai: 11, value: cgmp_batch.dataprod.strftime('%d/%m/%Y') },
                    { name: 'expiration_date',    ai: 17, value: cgmp_batch.datascaden.strftime('%d/%m/%Y') },
                    { name: 'sellable_units',     ai: 37, value: get_sellable_units(cgmp_batch.codeprod) },
                    { name: 'po_number',          ai: 400, value: cgmp_batch.numero_po } ]
  end

  def to_s
    @attributes.map { |data| "%#{data[:ai]}%#{data[:value]}" }.join('')
  end

  def batch_code
    @attributes.detect { |attribute| attribute[:name] == 'batch_code' }[:value]
  end

private

  def get_sellable_units(batch_code)
    prod = CGMPRecord.new('IMP_PROD').where(batch_pf: batch_code)
    prod.select    { |record| /\A43-\w+\Z/ =~ record.codice_mp }
        .group_by  { |record| record.codice_mp }
        .map       { |_, records| records.map(&:qta_reale).reduce(0, :+) }
        .max
  end
end
