# frozen_string_literal: true

module OpenInvoice

  # module to help file streaming
  module FileStreaming

    private

    # method to transfer file data from aws object
    # in development uses send_file from local file
    # @param [CarrierWave::Uploader::Base] carrierwave_file_attribute
    # @param [Boolean] inline
    def stream_file(carrierwave_file_attribute, inline=false)
      # CarrierWave::Storage::AWSFile (or CarrierWave::SanitizedFile for dev)
      aws_file = carrierwave_file_attribute.file
      # Aws::S3::Object (or string with file path for dev)
      s3_object = aws_file.file

      # set response headers with content type, file size and file name
      response.set_header('Content-Type', aws_file.content_type)
      response.set_header('Content-Length', aws_file.size)
      response.set_header('Content-Disposition',
                          "#{inline ? 'inline' : 'attachment'}; filename=\"#{aws_file.filename}\"")

      # if aws storage used
      if OpenInvoice.config.storage_aws?
        # for Aws::S3::Object we use method #get to read file in chunks
        self.response_body = s3_object.enum_for(:get)
      else # for :file storage
        # send_data directly
        response.send_file s3_object
      end
    end

  end

end
