RSpec.describe NewProductionOrderCheck do
  context '::call' do
    it 'returns true when record has state 0 and expiration date is not null' do
      cgmp_batch_0 = spy('cGMP batch', stato: '0', datascaden: Date.today)

      expect(NewProductionOrderCheck.call(cgmp_batch_0)).to eq(true)
    end

    it 'returns false when record does not have state 0' do
      cgmp_batch_1 = spy('cGMP batch',  stato: '1', datascaden: Date.today)

      expect(NewProductionOrderCheck.call(cgmp_batch_1)).to eq(false)
    end

    it 'returns false when record does not have expiration date' do
      cgmp_batch_1 = spy('cGMP batch',  stato: '0', datascaden: nil)

      expect(NewProductionOrderCheck.call(cgmp_batch_1)).to eq(false)
    end
  end
end
