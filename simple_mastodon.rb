require './register'
require './client'

class SimpleMastodon
  include Register

  def initialize
    @client = init_app
    @ltl_since = 0
    @notification_since = 0
  end

  def local_time_line
    ret_val = []
    @client.public_timeline(since_id: @ltl_since, local: true).each do |status|
      ret_val << status_to_string(status)
    end

    # 時系列順にするためreverseを行う
    ret_val.reverse
  end

  def notifications
    perform_request(:get, '/api/v1/notifications', since_id: @notification_since).reverse
  end

  def toot(content, visibility = nil, to = nil)
    @client.create_status(content, visibility, to)
  end

  private

  def perform_request(request_method, path, options = {})
    Mastodon::REST::Request.new(@client, request_method, path, options).perform
  end

  def status_to_string(status)
    account = status.account
    content = status.content

    # idの更新
    @ltl_since = status.content.id if @ltl_since < status.content.id

    display_name = account.display
    display_name ||= account.acct
    [display_name, "@" + account.acct, content_convert(content)]
  end

  def content_convert(content)
    content.gsub!("<br \/>", "\n")
    remove_tag(content)
  end

  def remove_tag(str)
    str.gsub(/<([^>]+)>/, "")
  end
end

SimpleMastodon.new.toot("テスト", "direct")
