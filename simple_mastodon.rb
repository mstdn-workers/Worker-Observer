require 'net/http'
require 'uri'
require 'json'
require 'pp'

# Mastodonの最低限的な機能を実装しているクラス
class SimpleMastodon
  NOTIFICATIONS_SINCE_FILE = ".notifications_since"
  LTL_SINCE_FILE = ".ltl_since"
  LTL_URI = "https://mstdn-workers.com/api/v1/timelines/public?local=true"

  def initialize
    begin
      @notifications_since = File.read(NOTIFICATIONS_SINCE_FILE).to_i
      @ltl_since = File.read(LTL_SINCE_FILE).to_i
    rescue
      @notifications_since ||= 0
      @ltl_since ||= 0
    end
  end

  # LTLを取得する。取得するデータは名前とusername, content
  def local_time_line
    ret_val = []

    uri = URI.parse(LTL_URI)
    json = Net::HTTP.get(uri)
    parsed = JSON.parse(json)
    parsed.each do |status|
      ret_val << extract_from_status(status)
    end
    File.write(LTL_SINCE_FILE, @ltl_since.to_s)

    # 時系列順にするためreverseを行う
    ret_val.reverse
  end

  # HTMLタグを削除したり、改行コードを改行に変化させるメソッド
  def content_convert(content)
    content.gsub!("<br \/>", "\n")
    remove_tag(content)
  end

  # statusからdisplay_name, username, contentなどを取得するメソッド
  def extract_from_status(status)
    account = status["account"]
    content = status["content"]

    # idの更新
    @ltl_since = status["id"] if @ltl_since < status["id"]

    # display_nameを取得する方法がattributesから直接引っ張ってくるしかなかった
    display = account["display_name"]
    display ||= account["acct"]
    {
      id: account["id"],
      display: display,
      username: account["acct"],
      content: content_convert(content),
      statuses_count: account["statuses_count"]
    }
  end

  def remove_tag(str)
    str.gsub(/<([^>]+)>/, "")
  end
end
