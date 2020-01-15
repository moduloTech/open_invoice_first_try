# frozen_string_literal: true

require 'active_model/model'

module OpenInvoice

  class << self

    # method to retrieve default configuration
    # result is a hash
    def defaults
      # build default config file name
      file = Engine.root.join('config', 'open_invoice.yml')
      # parse yml file
      YAML.load_file(file)
    end

    # cached configuration instance
    def config
      # initialize config instance with default settings
      @config ||= Configuration.new(defaults)
    end

    # root method to load the engine
    # most fragile parts are loaded after this method
    # when using the engine one MUST call it even not changing the default config:
    # OpenInvoice.configure
    def configure
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
      # load application mailer for engine's mailers
      require_relative 'application_mailer'
    end

    # shorthand for app_name
    delegate :app_name, to: :config

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
    # @return [Class]
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

    # helper to check if aws is used
    # @return [Boolean]
    def storage_aws?
      storage.present? && storage.to_sym == :aws
    end

    ### Mailer options

    # mailer base class string "::ActionMailer"
    attr_accessor :mailer_base
    # mailer default from field "no-reply@local.dev"
    attr_writer :mailer_default_from

    # mailer class helper
    # @return [Class]
    def mailer_base_class
      mailer_base.constantize
    end

    # default from helper. avoids nil result
    # @return [String]
    def mailer_default_from
      @mailer_default_from || "#{app_name} <no-reply@#{domain}>"
    end

    attr_accessor :mailer_layout

    validates :mailer_base, :mailer_default_from, :mailer_layout, presence: true

    ### General options

    DEFAULT_DOMAIN = 'local.dev'
    DEFAULT_NAME = 'Open Invoice'
    SUPPORTED_SESSION_STORE = %i[cache_store cookie_store mem_cache_store
                                 active_record_store].freeze
    SUPPORTED_CACHE_STORE = %i[file_store mem_cache_store memory_store null_store
                               redis_cache_store].freeze

    # option to inherit base controller. defaults to "::ApplicationController"
    attr_accessor :controller_base

    # controller class helper
    # @return [Class]
    def controller_base_class
      controller_base.constantize
    end

    # option to allow errors slip through catchers and raise at the root level
    attr_accessor :raise_in_development
    # option to be the domain of the app "example.com"
    attr_writer :domain
    # option to be the host of the app "https://www.example.com"
    attr_accessor :host
    # option to serve as app name for custom installs
    attr_accessor :app_name
    # option to catch all errors inside engines root controller or not
    attr_accessor :catch_engine_errors
    # option to choose storage for session and cache
    attr_accessor :dummy_session_store, :dummy_cache_store

    # helper for raise_in_development
    # @return [Boolean]
    def raise_in_development?
      @raise_in_development.present?
    end

    # app domain
    # @return [String]
    def domain
      @domain || DEFAULT_DOMAIN
    end

    # require domain, host, app_name to be present
    validates :app_name, :domain, :host, presence: true
    # require stores
    validates :dummy_session_store, :dummy_cache_store, presence: true
    # validate stores against whitelist
    validates :dummy_session_store, inclusion: { in: SUPPORTED_SESSION_STORE }
    validates :dummy_cache_store, inclusion: { in: SUPPORTED_CACHE_STORE }

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
