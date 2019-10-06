set :user, ENV['USER']
server ENV['SERVER_IP'], user: fetch(:user), roles: %w[app]
set :ssh_key_file, ENV.fetch('SSH_KEY') { '~/.ssh/id_rsa.pub' }
set :ssh_options, keys: [fetch(:ssh_key_file)], forward_agent: true

set :ssh_key_name, ENV.fetch('SSH_KEY_NAME') { 'open_invoice_key' }
set :do_token, ENV['DO_TOKEN']
set :vm_size, 's-1vcpu-1gb'
set :vm_region, 'fra1'
set :vm_name, 'test-api-create-droplet'
set :vm_image, 'ubuntu-18-04-x64'
