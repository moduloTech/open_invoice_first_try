# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# root ORM class
class ApplicationRecord < ActiveRecord::Base

  # mark as abstract
  self.abstract_class = true

  # @return [String] model path for rails_admin
  def self.admin_model_name
    # uses underscore of the class name and replaces slashes "/" with tilde "~"
    self.class.name.underscore.gsub('/', '~')
  end

  # allow to call :admin_model_name from instance
  delegate :admin_model_name, to: :class

end
