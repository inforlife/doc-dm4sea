Dotenv.load("#{App.root}/.env")

Mail.defaults do
  delivery_method :smtp, {  address:        ENV['SMTP_ADDRESS'],
                            port:           587,
                            domain:         ENV['SMTP_DOMAIN'],
                            user_name:      ENV['SMTP_USERNAME'],
                            password:       ENV['SMTP_PASSWORD'],
                            authentication: 'login' }
end
