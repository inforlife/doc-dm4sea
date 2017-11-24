namespace :db do
  desc 'Create database'
  # bundle exec rake db:create['test']
  task :create, [:env] do |t, args|
    require 'sqlite3'

    args.with_defaults(env: 'development')

    environment = ENV['APP_ENVIRONMENT'] || args[:env]
    database_name = "dm4sea_#{environment}.db"

    unless File.file?("db/#{database_name}")
      db = SQLite3::Database.new "db/#{database_name}"

      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS batches (
          batch VARCHAR(30) PRIMARY KEY,
          fdl INT,
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL

      db.execute <<-SQL
        CREATE INDEX batches_batch
        ON batches (batch);
      SQL

      db.execute <<-SQL
        CREATE INDEX batches_fdl
        ON batches (fdl);
      SQL

      puts "Database #{database_name} created"
    else
      puts "Database #{database_name} already exists"
    end
   end

   desc 'Delete database content'
   # bundle exec rake db:purge['test']
   task :purge, [:env] do |t, args|
     require 'sqlite3'

     args.with_defaults(env: 'development')

     environment = ENV['APP_ENVIRONMENT'] || args[:env]
     database_name = "dm4sea_#{environment}.db"

     db = SQLite3::Database.new "db/#{database_name}"

     db.execute <<-SQL
       DELETE FROM batches;
     SQL

    puts "Database #{database_name} purged"
  end
end

namespace :datamatrix do
  desc 'Generate and email datamatrix on demand'
  # bundle exec rake datamatrix:send['LOT01']
  task :send, [:batch_code] do |t, args|
    require_relative 'config/application'

    batch_code = args[:batch_code]
    EmailDataMatrix.for_batch(batch_code)

    puts "Datamatrix for #{batch_code} generated and emailed"
  end
end
