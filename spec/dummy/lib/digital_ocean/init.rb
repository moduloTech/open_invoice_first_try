# frozen_string_literal: true

module DigitalOcean

  # Author: varaby_m@modulotech.fr
  class Init

    def initialize(access_token:, **options)
      require 'droplet_kit'
      @options = options
      @client = DropletKit::Client.new(access_token: access_token)
    end

    # @return [DropletKit::Droplet]
    def droplet
      @droplet ||=
        begin
          existing_droplet = client.droplets.all.find { |x| x.name == get(:vm_name) }

          if existing_droplet
            existing_droplet
          else
            droplet = DropletKit::Droplet.new(
              name: get(:vm_name), region: get(:vm_region), image: get(:vm_image),
              size: get(:vm_size), ssh_keys: [ssh_key.id]
            )
            client.droplets.create(droplet)

            droplet
          end
        end
    end

    # @return [DropletKit::SSHKey]
    def ssh_key
      existing_key = client.ssh_keys.all.find { |x| x.fingerprint == ssh_key_fingerprint }
      return existing_key if existing_key

      public_key = File.read(get(:ssh_key_file))
      ssh_key = DropletKit::SSHKey.new(
        name: get(:ssh_key_name), fingerprint: ssh_key_fingerprint, public_key: public_key
      )
      client.ssh_keys.create(ssh_key)

      ssh_key
    end

    # @return [String] ip_address
    def wait_ip
      ipv4 = []
      limit = 60.seconds.from_now

      loop do
        ipv4 = droplet.networks[:v4]
        break if ipv4.present?
        break if Time.current > limit

        @droplet = client.droplets.find(id: droplet.id)
      end

      ipv4.first&.ip_address || 'timeout'
    end

    def firewall
      # TODO
    end

    private

    attr_reader :client

    def set(key, value)
      @options[key] = value
    end

    def get(key)
      @options[key]
    end

    # @return [String]
    def ssh_key_fingerprint
      @ssh_key_fingerprint ||=
        `ssh-keygen -E md5 -lf #{get(:ssh_key_file)}`[/(?<=MD5:)(.*?)(?=\s)/]
    end

  end

end
