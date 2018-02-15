RSpec.describe BagCheck do
  context '::call' do
    it 'returns false when record has codeprod starting with 53' do
      cgmp_batch_0 = spy('cGMP batch', codeprod: '53-xxxxxx')

      expect(BagCheck.call(cgmp_batch_0)).to eq(false)
    end

    it 'returns true otherwise' do
      cgmp_batch_1 = spy('cGMP batch', codeprod: '51-xxxxxx')

      expect(BagCheck.call(cgmp_batch_1)).to eq(true)
    end
  end
end
