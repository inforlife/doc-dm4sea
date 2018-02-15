RSpec.describe BagCheck do
  context '::call' do
    it 'returns false when record has codeprod starting with 53-' do
      cgmp_batch_0 = spy('cGMP batch', codeprod: '53-xxxxxx')

      expect(BagCheck.call(cgmp_batch_0)).to eq(false)
    end

    it 'returns false when record has codeprod starting with 56-' do
      cgmp_batch_1 = spy('cGMP batch', codeprod: '56-xxxxxx')

      expect(BagCheck.call(cgmp_batch_1)).to eq(false)
    end

    it 'returns false when record has codeprod starting with 790' do
      cgmp_batch_2 = spy('cGMP batch', codeprod: '790xxx')

      expect(BagCheck.call(cgmp_batch_2)).to eq(false)
    end

    it 'returns true otherwise' do
      cgmp_batch_3 = spy('cGMP batch', codeprod: '51-xxxxxx')

      expect(BagCheck.call(cgmp_batch_3)).to eq(true)
    end
  end
end
