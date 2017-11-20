RSpec.describe ListenToFileModification do
  context '::to' do
    context 'when an error is raised' do
       it 'calls ErrorHandler' do
         error_handler_class = class_spy('ErrorHandler').as_stubbed_const

         allow(Listen).to receive(:to) { raise Exception }

         ListenToFileModification.to('path/to/cgmp')
         expect(error_handler_class).to have_received(:call)
       end
     end
  end
end
