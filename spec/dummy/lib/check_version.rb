# frozen_string_literal: true

require 'rest-client'

# Author: varaby_m@modulotech.fr
# check remote version of dummy app and compare with current running dummy version
class CheckVersion

  # github url for raw json file retrieve
  REPO_URL = 'https://raw.githubusercontent.com/moduloTech/open_invoice/master'
  # local relative path to version.json is appended to github url
  VERSION_URL = "#{REPO_URL}/spec/dummy/lib/version.json"
  # current running dummy instance version
  LOCAL_VERSION = Gem::Version.new(Dummy::VERSION)

  # constructor
  def initialize
    # allow to retry rest-client request 3 times
    @retries = 3
  end

  # check if current instance is outdated
  #
  # @return [Boolean]
  def outdated?
    # compare local version with remote one
    LOCAL_VERSION < remote_version
  end

  # remote version loaded
  #
  # @return [Gem::Version]
  def remote_version
    @remote_version ||= Gem::Version.new(git_version[:version])
  end

  # changes that are released on github, but missing in the current app
  #
  # @return [Hash]
  def missing_changes
    @missing_changes ||= begin
      # collector for missing changes
      missing_changes = {}
      git_version[:changes].each { |version, changes|
        # do not include changes for current version or older
        break if Gem::Version.new(version) <= LOCAL_VERSION

        # collect changes for newer version
        missing_changes[version] = changes
      }
      missing_changes
    end
  end

  private

  # retrieve remote version.js file
  #
  # @return [Hash]
  def git_version
    @git_version ||=
      begin
        # read json file
        response = RestClient.get(VERSION_URL)
        # parse it to hash with indifferent access
        JSON.parse(response.body, object_class: HashWithIndifferentAccess)
      rescue RestClient::Timeout
        # on timeout retry
        @retries -= 1
        retry unless @retries.zero?

        # return empty hash with zero version
        { version: '0.0.0' }
      end
  end

end
