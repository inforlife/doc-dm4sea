RSpec.describe EmailDataMatrix do
  let(:cgmp_table_class)      { class_spy('CGMPRecord').as_stubbed_const }
  let(:cgmp_table)            { spy('cGMP table') }
  let(:database_record_class) { class_spy('DatabaseRecord').as_stubbed_const }
  let(:database_record)       { spy('database record', code: 'LOT2') }
  let(:log_action_class)      { class_spy('LogAction').as_stubbed_const }
  let(:log_action)            { spy('email file') }
  let(:email_file_class)      { class_spy('EmailFile').as_stubbed_const }
  let(:email_file)            { spy('email file') }
  let(:data_matrix_pdf_class) { class_spy('DataMatrixPdf').as_stubbed_const }
  let(:data_matrix_pdf)       { spy('datamatrix pdf') }

  before do
    allow(cgmp_table_class).to receive(:new) { cgmp_table }
  end

  context '::after_batch_record_print' do
    let(:new_production_order_check_class)  { class_spy('NewProductionOrderCheck').as_stubbed_const }
    let(:not_yet_stored_check_class)        { class_spy('NotYetStoredCheck').as_stubbed_const }
    let(:cgmp_record)                       { spy('cGMP record', batch: 'LOT1') }

    before do
      allow(cgmp_table).to receive(:last) { cgmp_record }
    end

    context 'when the modification to LOTTI is the addition of a new production order not processed yet' do
      before do
        allow(new_production_order_check_class).to receive(:call) { true }
        allow(not_yet_stored_check_class).to receive(:call)       { true }
        allow(database_record_class).to receive(:new)             { database_record }
      end

      it 'adds the batch to database with fdl set to false' do
        EmailDataMatrix.after_batch_record_print
        expect(database_record_class).to have_received(:new).with(batch: 'LOT1', fdl: false)
        expect(database_record).to have_received(:save)
      end
    end

    context 'when the modification to LOTTI is not the addition of a new production order' do
      before do
        allow(new_production_order_check_class).to receive(:call)   { false }
      end

      context 'and a batch record has been printed for a batch which previously did not have the batch record printed' do
        let(:cgmp_record)           { spy('cGMP record', fdl: true) }

        before do
          allow(database_record_class).to receive(:where)           { [database_record] }
          allow(cgmp_table).to receive(:first).with(batch: 'LOT2')  { cgmp_record }
          allow(data_matrix_pdf_class).to receive(:new)             { data_matrix_pdf }
        end

        it 'generates the datamatrix' do
          allow(email_file_class).to receive(:new) { email_file }

          EmailDataMatrix.after_batch_record_print
          expect(data_matrix_pdf).to have_received(:save)
        end

        it 'emails the datamatrix' do
          allow(email_file_class).to receive(:new) { email_file }

          EmailDataMatrix.after_batch_record_print
          expect(email_file).to have_received(:deliver)
        end

        it 'logs the email send' do
          allow(log_action_class).to receive(:new) { log_action }

          EmailDataMatrix.after_batch_record_print
          expect(log_action).to have_received(:deliver)
        end

        it 'updates the batch setting fdl to true' do
          allow(email_file_class).to receive(:new) { email_file }

          EmailDataMatrix.after_batch_record_print
          expect(database_record).to have_received(:update).with(fdl: true)
        end
      end
    end
  end

  context '::for_batch' do
    let(:cgmp_record) { spy('cGMP record', batch: 'LOT3') }

    before do
      allow(database_record_class).to receive(:where)           { [database_record] }
      allow(cgmp_table).to receive(:first).with(batch: 'LOT3')  { cgmp_record }
      allow(data_matrix_pdf_class).to receive(:new)             { data_matrix_pdf }
    end

    it 'finds the provided batch' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT3')
      expect(cgmp_table).to have_received(:first).with(batch: 'LOT3')
    end

    it 'generates the datamatrix' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT3')
      expect(data_matrix_pdf).to have_received(:save)
    end

    it 'emails the datamatrix' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT3')
      expect(email_file).to have_received(:deliver)
    end

    it 'logs the email send' do
      allow(log_action_class).to receive(:new) { log_action }

      EmailDataMatrix.for_batch('LOT3')
      expect(log_action).to have_received(:deliver)
    end

    it 'updates the batch setting fdl to true' do
      allow(email_file_class).to receive(:new) { email_file }

      EmailDataMatrix.for_batch('LOT3')
      expect(database_record).to have_received(:update).with(fdl: true)
    end
  end
end
