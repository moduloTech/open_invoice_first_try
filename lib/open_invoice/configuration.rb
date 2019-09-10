# frozen_string_literal: true

require 'active_model/model'

# Author: varaby_m@modulotech.fr
module OpenInvoice

  def self.defaults
    file = Engine.root.join('config', 'open_invoice.yml')
    YAML.load_file(file)
  end

  def self.config
    @config ||= Configuration.new(defaults)
  end

  def self.configure
    yield(config)

    raise ConfigurationInvalid.new(config) unless config.valid?

    require "open_invoice/orm/#{config.orm}"
    require_relative 'carrier_wave_configure'
  end

  class Configuration

    include ActiveModel::Model

    ### ORMs

    SUPPORTED_ORMS = %w[active_record].freeze

    attr_accessor :orm, :orm_base

    validates :orm, presence: true, inclusion: { in: SUPPORTED_ORMS }
    validates :orm_base, presence: true

    def orm_base_class
      orm_base.constantize
    end

    ### AWS

    DEFAULT_DIR_PREFIX = 'uploads'

    attr_accessor :aws_key_id, :aws_secret, :aws_region, :aws_bucket
    attr_writer :aws_dir_prefix

    validates :aws_key_id, :aws_secret, :aws_region, :aws_bucket,
              presence: true, if: -> { Rails.env.production? }

    def init_aws!
      @aws_key_id =     ENV['AWS_KEY_ID']
      @aws_secret =     ENV['AWS_SECRET']
      @aws_region =     ENV['AWS_REGION']
      @aws_bucket =     ENV['AWS_BUCKET']
      @aws_dir_prefix = ENV['AWS_DIR_PREFIX']
    end

    def aws_dir_prefix
      @aws_dir_prefix || DEFAULT_DIR_PREFIX
    end

  end

  class ConfigurationInvalid < StandardError

    def initialize(config)
      super(config.errors.full_messages.join('. '))
    end

  end

end
