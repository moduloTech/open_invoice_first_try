# frozen_string_literal: true

module OpenInvoice

  # Author: varaby_m@modulotech.fr
  module FileStreaming

    private

    # method to transfer file data from aws object
    # in development uses send_file from local file
    def stream_file(carrierwave_file_attribute)
      # CarrierWave::Storage::AWSFile (or CarrierWave::SanitizedFile for dev)
      aws_file = carrierwave_file_attribute.file
      # Aws::S3::Object (or string with file path for dev)
      s3_object = aws_file.file

      # set response headers with content type, file size and file name
      response.set_header('Content-Type', aws_file.content_type)
      response.set_header('Content-Length', aws_file.size)
      response.set_header('Content-Disposition', "attachment; filename=\"#{aws_file.filename}\"")

      # if file path
      if s3_object.is_a?(String)
        # we received local file - send_data directly
        send_file s3_object
      else
        # for Aws::S3::Object we use method #get to read file in chunks
        self.response_body = s3_object.enum_for(:get)
      end
    end

  end

end
