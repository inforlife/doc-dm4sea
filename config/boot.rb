require_relative 'application.rb'

LOGGER.info("Booting - DM4SEA #{ IO.read(App.root + '/RELEASE').strip } started in #{App.env}.")

ListenToFileModification.to(ENV['CGMP_PATH']) do
  EmailDataMatrix.after_batch_record_print
end
