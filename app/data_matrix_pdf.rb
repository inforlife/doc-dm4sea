class DataMatrixPdf
  attr_reader :file_path

  def initialize(variable_data)
    @variable_data = variable_data
    @file_path = "#{App.root}/pdfs/#{@variable_data.batch_code}.pdf"
    @pdf = DataMatrixPrawnView.new
  end

  def save
    @pdf.human_readible(@variable_data)
    @pdf.datamatrix(@variable_data)
    @pdf.save_as(@file_path)
    self
  end
end
