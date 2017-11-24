class DataMatrixPrawnView
  include Prawn::View

  def human_readible(data)
    text data.to_s
  end

  def datamatrix(data)
    image_name = "#{App.root}/images/#{data.batch_code}.png"
    stdout, stderr, status = Open3.capture3("bwip-js --bcid=datamatrix --text='#{data.to_s}' #{image_name}")

    if status.success?
      image image_name, at: [200,700]
    end
  end
end
