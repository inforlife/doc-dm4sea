RSpec.describe LogAction do
  context '#method_missing' do
    let(:logger)  { spy('logger') }
    let(:inner)   { spy('inner') }

    it 'logs the execution of any methods of the wrapped object' do
      LogAction.new(inner, log_to: logger).call
      expect(logger).to have_received(:info)
    end

    it 'calls the method of the wrapped object' do
      LogAction.new(inner).call
      expect(inner).to have_received(:call)
    end
  end
end
