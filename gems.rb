source 'https://rubygems.org'

gem 'listen',   '3.1.5'
gem 'dbf',      '3.1.1'
gem 'sqlite3',  '1.3.13'
gem 'rake',     '11.3.0'
gem 'prawn',    '2.2.0'
gem 'mail',     '2.7.0'

group :development, :test do
  gem 'dotenv', '2.2.1'
end

group :development, :test, :ci do
  gem 'rspec',   '3.7'
end
