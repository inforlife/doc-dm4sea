Dotenv.load("#{App.root}/.env")

Mail.defaults do
  delivery_method :test
end
