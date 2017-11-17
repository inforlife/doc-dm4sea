RSpec.describe DatabaseRecord do
  let(:database_record) { DatabaseRecord.new(batch: 'LOT1', fdl: true) }
  let(:time)            { spy('time', now: 'now') }
  let(:database)        { spy('database') }

  before do
    `bundle exec rake db:purge['test']`

    stub_const('Time', time)
    stub_const('DatabaseRecord::DB', database)
  end

  context '#save' do
    it 'inserts the recod into the database' do
      database_record.save
      expect(database).to have_received(:execute).with('INSERT INTO batches VALUES ( ?, ?, ?, ? )', ['LOT1', 1, time.now, time.now])
    end

    it 'returns self' do
      record = database_record
      expect(record.save).to eq(record)
    end
  end

  context '#update' do
    it 'sets the fdl value' do
      database_record.update(fdl: false)
      expect(database).to have_received(:execute).with(/UPDATE batches SET fdl = 0[\w\s=,'+:-]+WHERE batch = 'LOT1'/)
    end

    it 'sets updated_at' do
        database_record.update(fdl: false)
        expect(database).to have_received(:execute).with(/UPDATE batches [\w\s=,'+:-]+updated_at = 'now' WHERE batch = 'LOT1'/)
    end

    it 'returns self' do
      record = database_record
      expect(record.update(fdl: false)).to eq(record)
    end
  end

  context '::where' do
    it 'fetches the records from the database' do
      DatabaseRecord.where(batch: 'LOT1', fdl: true)
      expect(database).to have_received(:execute).with("SELECT * FROM batches WHERE batch = 'LOT1' AND fdl = 1")
    end

    it 'returns an object for each record' do
      allow(database).to receive(:execute) { [['LOT1', 1, '2017-11-14 18:06:11 +0800', '2017-11-14 18:06:11 +0800']] }

      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true)).to be_a(Array)
      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true).first).to be_a(DatabaseRecord)
      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true).first.batch).to eq('LOT1')
      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true).first.fdl).to eq(true)
      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true).first.created_at).to eq(Time.parse('2017-11-14 18:06:11 +0800'))
      expect(DatabaseRecord.where(batch: 'LOT1', fdl: true).first.updated_at).to eq(Time.parse('2017-11-14 18:06:11 +0800'))
    end
  end
end
