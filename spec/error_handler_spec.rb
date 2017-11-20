RSpec.describe ErrorHandler do
  context '::call' do
    it 'logs the error to Rollbar' do
      rollbar_class = class_spy('Rollbar').as_stubbed_const
      error         = spy('error')

      ErrorHandler.call(error)
      expect(rollbar_class).to have_received(:error).with(error)
    end
  end
end
