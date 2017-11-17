RSpec.describe NewProductionOrderCheck do
  context '::call' do
    it 'returns true when record has state 0' do
      cgmp_batch_0 = spy('cGMP batch', stato: '0')

      expect(NewProductionOrderCheck.call(cgmp_batch_0)).to eq(true)
    end

    it 'returns false when record does not have state 0' do
      cgmp_batch_1 = spy('cGMP batch',  stato: '1')

      expect(NewProductionOrderCheck.call(cgmp_batch_1)).to eq(false)
    end
  end
end
