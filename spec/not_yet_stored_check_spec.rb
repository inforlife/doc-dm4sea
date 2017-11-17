RSpec.describe NotYetStoredCheck do
  context '::call' do
    before do
      `bundle exec rake db:purge['test']`
    end

    let(:cgmp_batch) { spy('cGMP batch', batch: '001') }

    it 'returns true when record is not found in the database' do
      expect(NotYetStoredCheck.call(cgmp_batch)).to eq(true)
    end

    it 'returns false when record is found in the database' do
      DatabaseRecord.new(batch: cgmp_batch.batch, fdl: true).save

      expect(NotYetStoredCheck.call(cgmp_batch)).to eq(false)
    end
  end
end
