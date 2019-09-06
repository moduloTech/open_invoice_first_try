# frozen_string_literal: true

require 'active_model/model'

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
  end

  class Configuration

    include ActiveModel::Model

    SUPPORTED_ORMS = %w[active_record].freeze

    attr_accessor :orm, :orm_base

    validates :orm, presence: true, inclusion: { in: SUPPORTED_ORMS }
    validates :orm_base, presence: true

    def orm_base_class
      orm_base.constantize
    end

  end

  class ConfigurationInvalid < StandardError

    def initialize(config)
      super(config.errors.full_messages.join('. '))
    end

  end

end
