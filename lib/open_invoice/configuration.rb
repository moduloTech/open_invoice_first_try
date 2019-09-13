# frozen_string_literal: true

require 'active_model/model'

module OpenInvoice

  # method to retrieve default configuration
  # result is a hash
  def self.defaults
    # build default config file name
    file = Engine.root.join('config', 'open_invoice.yml')
    # parse yml file
    YAML.load_file(file)
  end

  # cached configuration instance
  def self.config
    # initialize config instance with default settings
    @config ||= Configuration.new(defaults)
  end

  # root method to load the engine
  # most fragile parts are loaded after this method
  # when using the engine one should call it even not changing the default config:
  # OpenInvoice.configure
  def self.configure
    # allow to configure the engine
    yield(config) if block_given?

    # validate config and raise if it is invalid
    raise ConfigurationInvalid.new(config) unless config.valid?

    # load orm. stub for future development
    require "open_invoice/orm/#{config.orm}"
    # load application record for engine's models
    require_relative 'application_record'
    # load carrierwave configuration
    require_relative 'carrier_wave_configure'
  end

  # Author: varaby_m@modulotech.fr
  # configuration instance for OpenInvoice engine
  class Configuration

    include ActiveModel::Model

    ### ORMs

    # supported orms
    SUPPORTED_ORM = %w[active_record].freeze

    # orm is name like :active_record or :mongoid
    # orm_base is a base class for models like "::ApplicationRecord"
    attr_accessor :orm, :orm_base

    # validate orm to be one of supported
    validates :orm, presence: true, inclusion: { in: SUPPORTED_ORM }
    # validate orm_base to be populated
    validates :orm_base, presence: true

    # orm class helper
    def orm_base_class
      orm_base.constantize
    end

    ### Storage

    SUPPORTED_STORAGE = %i[aws file].freeze

    # aws credentials
    attr_accessor :aws_key_id, :aws_secret, :aws_region, :aws_bucket

    # prefix for file storage
    # some add-ons on heroku (cloud-cube) have single bucket and
    # distinguish apps by directory prefix. we need to add this prefix to each
    # stored file.
    # e.g. prefix is "123xyz". all files' paths should begin with it:
    # "123xyz/some_file.pdf"
    # "123xyz/some_file_other_file.pdf"
    # "123xyz/public/file_in_public_folder.pdf"
    # when using file storage you can specify relative links to public folder like:
    # "uploads" -> files would be stored to "rails_root/public/uploads"
    # or you can specify absolute path starting with slash
    # "/some_folder/files"
    attr_accessor :dir_prefix

    # carrierwave storage for files
    attr_accessor :storage

    # aws credentials are required in production
    validates :aws_key_id, :aws_secret, :aws_region, :aws_bucket,
              presence: true, if: :storage_aws?
    # storage should be one of: :aws, :file
    validates :storage, inclusion: { in: SUPPORTED_STORAGE }

    # method to populate all required aws credentials from env
    def init_aws!
      @aws_key_id = ENV['AWS_KEY_ID']
      @aws_secret = ENV['AWS_SECRET']
      @aws_region = ENV['AWS_REGION']
      @aws_bucket = ENV['AWS_BUCKET']
      @dir_prefix = ENV['DIR_PREFIX']
    end

    def storage_aws?
      storage.present? && storage.to_sym == :aws
    end

    ### General options

    # option to allow errors slip through catchers and raise at the root level
    attr_accessor :raise_in_development

    # helper for raise_in_development
    def raise_in_development?
      @raise_in_development.present?
    end

  end

  # error class for invalid openinvoice configuration
  class ConfigurationInvalid < StandardError

    # require config to be passed to initialize
    def initialize(config)
      # takes errors from config
      super(config.errors.full_messages.join('. '))
    end

  end

end
