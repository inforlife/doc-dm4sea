RSpec.describe DataMatrixPdf do
  context '#save' do
    let(:prawn_view_class)  { class_spy('DataMatrixPrawnView').as_stubbed_const }
    let(:prawn_view)        { spy('prawn view') }
    let(:variable_data)     { spy('variable data') }

    before do
      allow(prawn_view_class).to receive(:new) { prawn_view }
      DataMatrixPdf.new(variable_data).save
    end

    it 'adds variable data in human readible form to the PDF' do
      expect(prawn_view).to have_received(:human_readible).with(variable_data)
    end

    it 'adds datamatrix generated from variable data to the PDF' do
      expect(prawn_view).to have_received(:datamatrix).with(variable_data)
    end
    it 'saves the PDF' do
      expect(prawn_view).to have_received(:save_as)
    end
  end
end
