# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  # base model for OpenInvoice engine
  class ApplicationRecord < OpenInvoice.config.orm_base_class

    # mark it as abstract class
    self.abstract_class = true

    # make class methods simple
    delegate :arel_table, :human_attribute_name, to: :class

  end

end
