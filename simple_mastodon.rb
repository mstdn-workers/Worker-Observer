require './register'
require './notifications'

class SimpleMastodon
  include Register
  include Notifications

  def initialize
    @client = init_app
    @since_id = 0
  end

  def local_time_line
    ret_val = []
    @client.public_timeline(since_id: @since_id, local: true).each do |status|
      ret_val << status_to_string(status)
    end

    # 時系列順にするためreverseを行う
    ret_val.reverse
  end

  private

  def status_to_string(status)
    account = status.account
    content = status.content

    # idの更新
    @since_id = status.content.id

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
