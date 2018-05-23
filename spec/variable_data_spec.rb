RSpec.describe VariableData do
  let(:cgmp_batch)        { spy('cGMP batch', codeprod: '12-000000',
                                              batch: 'LOT1',
                                              dataprod: Date.new(2017,11,18),
                                              datascaden: Date.new(2020,11,18),
                                              numero_po: '001234567890') }
  let(:cgmp_table_class)  { class_spy('CGMPRecord').as_stubbed_const }
  let(:cgmp_table)        { spy('cGMP table') }
  let(:imp_prod1)         { spy('imp prod 1', codice_mp: '21-000000', qta_reale: 1000) }
  let(:imp_prod2)         { spy('imp prod 2', codice_mp: '43-000001', qta_reale: 99) }
  let(:imp_prod3)         { spy('imp prod 3', codice_mp: '43-000002', qta_reale: 50) }
  let(:imp_prod4)         { spy('imp prod 4', codice_mp: '43-000002', qta_reale: 50) }

  before do
    allow(cgmp_table_class).to receive(:new).with('IMP_PROD') { cgmp_table }
    allow(cgmp_table).to receive(:where)                      { [imp_prod1, imp_prod2, imp_prod3, imp_prod4] }
  end

  context '#to_s' do
    it 'returns its attributes as string' do
      expect(VariableData.new(cgmp_batch).to_s).to eq('%93%12-000000%10%LOT1%11%18/11/2017%17%18/11/2020%37%100%400%001234567890')
    end
  end

  context '#batch_code' do
    it 'returns the batch code froms its attributes' do
      expect(VariableData.new(cgmp_batch).batch_code).to eq('LOT1')
    end
  end
end
