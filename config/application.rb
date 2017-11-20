require 'bundler'
require 'open3'

class App
  def self.name
    'DM4SEA'
  end

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.env
    ENV['APP_ENVIRONMENT'] || 'development'
  end
end

Bundler.require(:default, App.env)

require_relative "environments/#{App.env}"
require_relative "../app/listen_to_file_modification"
require_relative "../app/email_data_matrix"
require_relative "../app/cgmp_record"
require_relative "../app/database_record"
require_relative "../app/new_production_order_check"
require_relative "../app/not_yet_stored_check"
require_relative "../app/variable_data"
require_relative "../app/data_matrix_pdf"
require_relative "../app/data_matrix_prawn_view"
require_relative "../app/email_file"
require_relative "../app/error_handler"
require_relative "../app/log_action"

LOGGER = Logger.new("#{App.root}/log/#{App.env}.log")
