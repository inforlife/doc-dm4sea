source 'https://rubygems.org'

gem 'listen',   '3.1.5'
gem 'dbf',      '3.1.1'
gem 'sqlite3',  '1.3.13'
gem 'rake',     '11.3.0'
gem 'prawn',    '2.2.0'
gem 'mail',     '2.7.0'

group :production do
  gem 'rollbar',  '2.15.5'
  # Rollbar suggests also installing Oj for JSON serialization.
  gem 'oj',       '3.3.9'
end

group :development, :test do
  gem 'dotenv', '2.2.1'
end

group :development, :test, :ci do
  gem 'rspec',   '3.7'
end
