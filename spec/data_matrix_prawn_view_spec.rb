RSpec.describe DataMatrixPrawnView do
  let(:prawn_document_class)  { class_spy('Prawn::Document').as_stubbed_const }
  let(:prawn_document)        { spy('prawn view') }
  let(:variable_data)         { spy('variable data', batch_code: 'LOT1', to_s: 'variable_data_as_string') }

  before do
    allow(prawn_document_class).to receive(:new) { prawn_document }
  end

  context '#human_readible' do
    it 'adds the variable data as text' do
      DataMatrixPrawnView.new.human_readible(variable_data)
      expect(prawn_document).to have_received(:text).with('variable_data_as_string')
    end
  end

  context '#datamatrix' do
    let(:open3_class) { class_spy('Open3').as_stubbed_const }
    let(:image_path)  { "#{App.root}/images/#{variable_data.batch_code}.png" }

    before do
      allow(prawn_document).to receive(:image)
      allow(open3_class).to receive(:capture3) { ['', '', spy('', success?: true)] }

      DataMatrixPrawnView.new.datamatrix(variable_data)
    end

    it 'generates the datamatrix as image' do
      expect(open3_class).to have_received(:capture3).with("bwip-js --bcid=datamatrix --text='variable_data_as_string' #{image_path}")
    end

    it 'adds the image to the PDF' do
      expect(prawn_document).to have_received(:image).with(image_path, instance_of(Hash))
    end
  end
end
