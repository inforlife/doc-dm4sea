RSpec.describe DataMatrixPdf do
  context '#save' do
    let(:prawn_view_class)  { class_spy('DataMatrixPrawnView').as_stubbed_const }
    let(:prawn_view)        { spy('prawn view') }
    let(:variable_data)     { spy('variable data') }
    let(:data_matrix_pdf)   { DataMatrixPdf.new(variable_data) }

    before do
      allow(prawn_view_class).to receive(:new) { prawn_view }
    end

    it 'adds variable data in human readible form to the PDF' do
      data_matrix_pdf.save
      expect(prawn_view).to have_received(:human_readible).with(variable_data)
    end

    it 'adds datamatrix generated from variable data to the PDF' do
      data_matrix_pdf.save
      expect(prawn_view).to have_received(:datamatrix).with(variable_data)
    end
    it 'saves the PDF' do
      data_matrix_pdf.save
      expect(prawn_view).to have_received(:save_as)
    end

    it 'returns self' do
      expect(data_matrix_pdf.save).to eq(data_matrix_pdf)
    end
  end
end
