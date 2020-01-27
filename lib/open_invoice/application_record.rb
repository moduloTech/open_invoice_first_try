# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # base model for OpenInvoice engine
  class ApplicationRecord < OpenInvoice.config.orm_base_class

    # mark it as abstract class
    self.abstract_class = true

    # make class methods simple
    delegate :arel_table, :human_attribute_name, to: :class

    # generate unique uuid token for specified field
    def generate_uuid_token(field)
      # repeat
      loop do
        # generate token
        token = self[field] = SecureRandom.uuid
        # validate it is unique
        break if self.class.where(field => token).none?
      end
    end

  end

end
