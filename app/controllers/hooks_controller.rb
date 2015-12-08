require 'openssl'
require 'base64'
require 'cgi'

class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_signature!

  def ping
    # client = Octokit::Client.new
    render plain: "OK", status: 200
  end

  private
    def verify_signature!
      request.body.rewind
      payload_body = request.body.read
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_TOKEN'], payload_body)
      render plain: "Bad signature", status: 403 unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
end
