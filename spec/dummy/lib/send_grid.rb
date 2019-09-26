# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# this class should map sendgrid's heroku credentials to dummy config
# to allow dummy send mails
class SendGrid

  ADDRESS = 'smtp.sendgrid.net'
  PORT = 587

  # apply config variables from sendgrid's env
  # https://devcenter.heroku.com/articles/sendgrid#actionmailer
  def self.settings
    {
      user_name:            ENV['SENDGRID_USERNAME'],
      password:             ENV['SENDGRID_PASSWORD'],
      domain:               OpenInvoice.config.domain,
      address:              ADDRESS,
      port:                 PORT,
      authentication:       :plain,
      enable_starttls_auto: true
    }
  end

end
