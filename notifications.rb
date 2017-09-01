# RubyのAPIのInterfaceで実装されていなかったため、自身で実装
module Notifications
  def notifications
    perform_request(:get, '/api/v1/notifications')
  end

  private

  def perform_request(request_method, path, options = {})
    Mastodon::REST::Request.new(@client, request_method, path, options).perform
  end
end
