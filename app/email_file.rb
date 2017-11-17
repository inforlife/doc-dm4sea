class EmailFile
  def initialize(file)
    @file_path = file.file_path
  end

  def deliver
    mail.deliver
  end

private

  def mail
    content =  File.read(@file_path)

    Mail.new do
      from     'dm4sea@infor.life'
      to        ENV['RECIPIENTS'].split('&')
      subject  'Datamatrix'
      body     'See attachment'
      add_file filename: 'datamatrix.pdf', content: content
    end
  end
end
