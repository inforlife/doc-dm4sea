require_relative 'application.rb'

ListenToFileModification.to(ENV['CGMP_PATH']) do
  EmailDataMatrix.after_batch_record_print
end
