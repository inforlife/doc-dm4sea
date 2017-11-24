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
   # bundle exec rake db:delete['test']
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
