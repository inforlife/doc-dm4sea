require_relative 'application.rb'

LOGGER.info("Booting - DM4SEA #{ IO.read(App.root + '/RELEASE').strip } started in #{App.env}.")

# Every day Monday to Friday at predefined time
scheduler = Rufus::Scheduler.new

scheduler.cron "0 #{ENV['HOUR_TO_RUN']} * * 1-5 Europe/Rome" do
  begin
    EmailDataMatrix.for_batch_records_printed_today
  rescue Exception => error
    ErrorHandler.call(error)
  end
end

scheduler.join

