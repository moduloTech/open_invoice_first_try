# frozen_string_literal: true

# this file is used to prepare engine's ORM ActiveRecord

# load orm adapter for active_record
require 'orm_adapter/adapters/active_record'
# load carrierwave's active_record adapter for stored files
require 'carrierwave/orm/activerecord'

# this capture can be used to add extra logic to active_record adapter
# it is executed after active_record is fully loaded
ActiveSupport.on_load(:active_record) do
  # extend
end
