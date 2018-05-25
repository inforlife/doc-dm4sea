RSpec.describe CGMPRecord do
  # DUMMY.DBF
  # {"CODEPROD"=>"10-000001", "BATCH"=>"LOT1", "PRT_FDL"=>false}
  # {"CODEPROD"=>"10-000002", "BATCH"=>"LOT2", "PRT_FDL"=>true}
  # {"CODEPROD"=>"10-000003", "BATCH"=>"LOT3", "PRT_FDL"=>true}

  before do
    ENV['CGMP_PATH'] = "#{App.root}/spec/fixtures"
  end

  context '#first' do
    it 'returns the first record in the file with matching attributes' do
      record = CGMPRecord.new('DUMMY').first(prt_fdl: true)

      expect(record.codeprod).to eq('10-000002')
      expect(record.batch).to eq('LOT2')
      expect(record.prt_fdl).to eq( true)
    end
  end

  context '#where' do
    it 'returns all the records the in file with matching attributes' do
      records = CGMPRecord.new('DUMMY').where(prt_fdl: true)

      expect(records.count).to eq(2)
      expect(records.first.batch).to eq('LOT2')
      expect(records.last.batch).to eq('LOT3')
    end
  end
end
