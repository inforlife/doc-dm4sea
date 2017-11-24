RSpec.describe EmailFile do
  before do
    Mail::TestMailer.deliveries.clear
  end

  context '#deliver' do
    let(:pdf_file)              { spy('PDF file', file_path: "#{App.root}/spec/fixtures/datamatrix.pdf") }
    let(:delivered_emails)      { Mail::TestMailer.deliveries }
    let(:delivered_email)       { delivered_emails.first }
    let(:delivered_attachments) { delivered_email.attachments }
    let(:delivered_attachment)  { delivered_email.attachments.first }

    before do
      EmailFile.new(pdf_file).deliver
    end

    context 'sends' do
      it 'an email' do
        expect(delivered_emails.count).to eq(1)
      end

      it 'from the default address' do
        expect(delivered_email.from).to eq(["dm4sea@infor.life"])
      end

      it 'to the predefined recipients' do
        expect(delivered_email.to).to eq(ENV['RECIPIENTS'].split('&'))
      end

      it 'with an attachment' do
        expect(delivered_attachments.count).to eq(1)
      end

      it 'with the PDF file as attachment' do
        expect(delivered_attachment.filename).to eq('datamatrix.pdf')
      end
    end
  end
end
