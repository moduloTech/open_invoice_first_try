OpenInvoice.configure do |config|
  if ENV['AWS_KEY_ID'].present?
    config.init_aws!
  elsif ENV['CLOUDCUBE_ACCESS_KEY_ID'].present?
    require 'cloud_cube'
    CloudCube.new.integrate(config)
  end
end
