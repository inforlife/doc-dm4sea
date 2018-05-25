class DatabaseRecord
  DB = SQLite3::Database.open "#{App.root}/db/dm4sea_#{App.env}.db"
  BooleanValue = { true => 1, false => 0 }

  attr_reader :batch, :fdl, :created_at, :updated_at

  def initialize(batch:, fdl:, created_at: '', updated_at: '')
    @batch = batch
    @fdl = fdl
    @created_at = created_at
    @updated_at = updated_at
  end

  def save
    @updated_at = @created_at = Time.now
    DB.execute "INSERT INTO batches VALUES ('#{batch}', #{BooleanValue[fdl]}, '#{created_at}', '#{updated_at}')"
    self
  end

  def self.where(attributes)
    where_clause = attributes.map do |key, value|
      if value.class == String
        "#{key} = '#{value}'"
      else
        "#{key} = #{value}".gsub(/(true|false)/) { "#{BooleanValue[$1 == 'true']}" }
      end
    end.join(' AND ')

    rows = DB.execute "SELECT * FROM batches WHERE #{where_clause}"
    rows.map { |row| DatabaseRecord.new(batch: row[0], fdl: BooleanValue.key(row[1]), created_at: Time.parse(row[2]), updated_at: Time.parse(row[3])) }
  end
end
