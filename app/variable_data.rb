class VariableData
  def initialize(cgmp_batch)
    @attributes = [ { name: 'product_code',       ai: 93, value: cgmp_batch.codeprod },
                    { name: 'batch_code',         ai: 10, value: cgmp_batch.batch },
                    { name: 'manufacturing_date', ai: 11, value: cgmp_batch.dataprod.strftime('%d/%m/%Y') },
                    { name: 'expiration_date',    ai: 17, value: cgmp_batch.datascaden.strftime('%d/%m/%Y') },
                    { name: 'sellable_units',     ai: 37, value: get_sellable_units(cgmp_batch) },
                    { name: 'po_number',          ai: 400, value: cgmp_batch.numero_po } ]
  end

  def to_s
    @attributes.map { |data| "%#{data[:ai]}%#{data[:value]}" }.join('')
  end

  def batch_code
    @attributes.detect { |attribute| attribute[:name] == 'batch_code' }[:value]
  end

private

  def get_sellable_units(cgmp_batch)
    (standard_sellable_units(cgmp_batch) * cgmp_batch.qt_teorica).ceil
  end

  def standard_sellable_units(cgmp_batch)
    formula = CGMPRecord.new('LEGAMI').where(codeprod: cgmp_batch.codeprod, metodopro: cgmp_batch.metodopro)
    formula.select { |item| /\A43-\w+\Z/ =~ item.codice_mp }.max_by(&:legame).legame
  end
end
