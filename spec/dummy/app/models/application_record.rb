# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# root ORM class
class ApplicationRecord < ActiveRecord::Base

  # mark as abstract
  self.abstract_class = true

  # model path for rails_admin
  def admin_model_name
    # uses underscore of the class name and replaces slashes "/" with tilde "~"
    self.class.name.underscore.gsub('/', '~')
  end

end
