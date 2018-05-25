RSpec.describe EmailDataMatrix do
  let(:cgmp_table_class)            { class_spy('CGMPRecord').as_stubbed_const }
  let(:cgmp_table)                  { spy('cGMP table') }
  let(:cgmp_record)                 { spy('cGMP record', batch: 'LOT1') }
  let(:database_record_class)       { class_spy('DatabaseRecord').as_stubbed_const }
  let(:database_record)             { spy('database record') }
  let(:log_action_class)            { class_spy('LogAction').as_stubbed_const }
  let(:log_action)                  { spy('email file') }
  let(:email_file_class)            { class_spy('EmailFile').as_stubbed_const }
  let(:email_file)                  { spy('email file') }
  let(:data_matrix_pdf_class)       { class_spy('DataMatrixPdf').as_stubbed_const }
  let(:data_matrix_pdf)             { spy('datamatrix pdf') }
  let(:variable_data_class)         { class_spy('VariableData').as_stubbed_const }
  let(:bag_check_class)             { class_spy('BagCheck').as_stubbed_const }
  let(:not_yet_stored_check_class)  { class_spy('NotYetStoredCheck').as_stubbed_const }

  before do
    allow(cgmp_table_class).to receive(:new) { cgmp_table }
  end

  context '::for_batch_records_printed_today' do
    it 'fetches from LOTTI the records for open production orders with printed batch record' do
      EmailDataMatrix.for_batch_records_printed_today
      expect(cgmp_table).to have_received(:where).with({ stato: '0', prt_fdl: true })
    end

    context 'for each record' do
      before do
        allow(EmailDataMatrix).to receive(:generate_and_email_datamatrix_for)
        allow(cgmp_table).to receive(:where)                { [cgmp_record] }
        allow(database_record_class).to receive(:new)       { database_record }
        allow(not_yet_stored_check_class).to receive(:call) { true }
        allow(bag_check_class).to receive(:call)            { true }
      end

      it 'checks the production order is for a lot of bags' do
        EmailDataMatrix.for_batch_records_printed_today
        expect(bag_check_class).to have_received(:call).with(cgmp_record)
      end

      it 'checks the production order has not been processed yet' do
        EmailDataMatrix.for_batch_records_printed_today
        expect(not_yet_stored_check_class).to have_received(:call).with(cgmp_record)
      end
    end

    context 'when the record is a new bag production order not yet processed' do
      before do
        allow(cgmp_table).to receive(:where)                { [cgmp_record] }
        allow(data_matrix_pdf_class).to receive(:new)       { data_matrix_pdf }
        allow(database_record_class).to receive(:new)       { database_record }
        allow(not_yet_stored_check_class).to receive(:call) { true }
        allow(bag_check_class).to receive(:call)            { true }
        allow(variable_data_class).to receive(:new)
      end

      it 'generates the datamatrix for the batch' do
        allow(email_file_class).to receive(:new)    { email_file }

        EmailDataMatrix.for_batch_records_printed_today
        expect(data_matrix_pdf).to have_received(:save)
        expect(variable_data_class).to have_received(:new).with(cgmp_record)
      end

      it 'emails the datamatrix' do
        allow(email_file_class).to receive(:new) { email_file }

        EmailDataMatrix.for_batch_records_printed_today
        expect(email_file).to have_received(:deliver)
      end

      it 'logs the email send' do
          allow(log_action_class).to receive(:new) { log_action }

          EmailDataMatrix.for_batch_records_printed_today
          expect(log_action).to have_received(:deliver)
      end

      it 'adds the batch to database' do
        allow(email_file_class).to receive(:new) { email_file }

        EmailDataMatrix.for_batch_records_printed_today
        expect(database_record_class).to have_received(:new).with(batch: cgmp_record.batch, fdl: true)
        expect(database_record).to have_received(:save)
      end
    end
  end

  context '::for_batch' do
    let(:cgmp_record) { spy('cGMP record', batch: 'LOT2') }

    before do
      allow(database_record_class).to receive(:where)           { [database_record] }
      allow(cgmp_table).to receive(:first).with(batch: 'LOT2')  { cgmp_record }
      allow(data_matrix_pdf_class).to receive(:new)             { data_matrix_pdf }
      allow(database_record_class).to receive(:new)             { database_record }
    end

    it 'finds the provided batch' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT2')
      expect(cgmp_table).to have_received(:first).with(batch: 'LOT2')
    end

    it 'generates the datamatrix' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT2')
      expect(data_matrix_pdf).to have_received(:save)
    end

    it 'emails the datamatrix' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT2')
      expect(email_file).to have_received(:deliver)
    end

    it 'logs the email send' do
      allow(log_action_class).to receive(:new) { log_action }

      EmailDataMatrix.for_batch('LOT2')
      expect(log_action).to have_received(:deliver)
    end

    context 'when the datamatix has been previusly generated for the batch' do
      it 'does not add the batch to database' do
        allow(email_file_class).to receive(:new)        { email_file }
        allow(database_record_class).to receive(:where) { [database_record] }

        EmailDataMatrix.for_batch('LOT2')
        expect(database_record_class).to_not have_received(:new)
      end
    end

    context 'when the datamatix has not been previusly generated for the batch' do
      it 'adds the batch to database' do
        allow(email_file_class).to receive(:new)        { email_file }
        allow(database_record_class).to receive(:where) { [] }

        EmailDataMatrix.for_batch('LOT2')
        expect(database_record_class).to have_received(:new).with(batch: cgmp_record.batch, fdl: true)
        expect(database_record).to have_received(:save)
      end
    end
  end
end
