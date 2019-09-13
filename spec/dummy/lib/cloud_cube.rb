# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
# this class should map cloudcube's heroku credentials to open-invoice config
# to allow carrierwave use aws to store files
class CloudCube

  # https://devcenter.heroku.com/articles/cloudcube#aws-region
  BUCKET_TO_REGION = {
    'cloud-cube'    => 'us-east-1',
    'cloud-cube-eu' => 'eu-west-1',
    'cloud-cube-jp' => 'ap-northeast-1'
  }.freeze

  # read env variables for cloudcube
  def initialize
    @key = ENV['CLOUDCUBE_ACCESS_KEY_ID']
    @secret = ENV['CLOUDCUBE_SECRET_ACCESS_KEY']
    @url = ENV['CLOUDCUBE_URL']
  end

  # apply config variables from cloudcube env
  def integrate(config)
    # apply credentials for login
    config.aws_key_id = @key
    config.aws_secret = @secret
    # sample url "https://cloud-cube-eu.s3.amazonaws.com/xyz123"
    # after being split with regex %r{http?s://|/|\.}
    # becomes array ["", "cloud-cube-eu", "s3", "amazonaws", "com", "xyz123"]
    # and we take second and last elements of the array using assignment decompose
    _, config.aws_bucket, *, config.dir_prefix = @url.split(%r{http?s://|/|\.})
    # determine region from bucket name
    config.aws_region = region(config.aws_bucket)
  end

  private

  # function determines aws region from bucket name
  # raises error when region is not found
  def region(bucket)
    BUCKET_TO_REGION[bucket] ||
      raise(NotImplementedError, "Unknown bucket #{bucket}")
  end

end
