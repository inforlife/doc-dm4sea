RSpec.describe VariableData do
  let(:cgmp_batch)        { spy('cGMP batch', codeprod: '12-000000',
                                              batch: 'LOT1',
                                              dataprod: Date.new(2017,11,18),
                                              datascaden: Date.new(2020,11,18),
                                              qt_teorica: 0.334) }
  let(:cgmp_table_class)  { class_spy('CGMPRecord').as_stubbed_const }
  let(:cgmp_table)        { spy('cGMP table') }
  let(:item_formula)      { spy('item formula', codice_mp: '43-000000', legame: 100) }

  before do
    allow(cgmp_table_class).to receive(:new).with('LEGAMI') { cgmp_table }
    allow(cgmp_table).to receive(:where)                    { [item_formula] }
  end

  context '#to_s' do
    it 'returns its attributes as string' do
      expect(VariableData.new(cgmp_batch).to_s).to eq('%93%12-000000%10%LOT1%11%18/11/2017%17%18/11/2020%37%34')
    end
  end

  context '#batch_code' do
    it 'returns the batch code froms its attributes' do
      expect(VariableData.new(cgmp_batch).batch_code).to eq('LOT1')
    end
  end
end
