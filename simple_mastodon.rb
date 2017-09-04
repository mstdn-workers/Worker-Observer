require './register'
require './client'

# Mastodonの最低限的な機能を実装しているクラス
class SimpleMastodon
  include Register

  def initialize
    @client = init_app
    @ltl_since = 0
    @notifications_since = 0
  end

  # LTLを取得する。取得するデータは名前とusername, content
  def local_time_line
    ret_val = []
    @client.public_timeline(since_id: @ltl_since, local: true).each do |status|
      ret_val << extract_from_status(status)
    end

    # 時系列順にするためreverseを行う
    ret_val.reverse
  end

  # 通知を取得する
  def notifications
    ret_val = perform_request(:get, '/api/v1/notifications', since_id: @notifications_since).reverse
    return [] if ret_val.empty?
    @notifications_since = ret_val[-1]["id"]
    ret_val
  end

  # tootする。visibilityはvisibility, toはin_reply_to_idを表している
  def toot(content, visibility = nil, to = nil)
    @client.create_status(content, visibility, to)
  end

  private

  # clientがselfになっていたため@clientに変更したperform_requestにした
  def perform_request(request_method, path, options = {})
    Mastodon::REST::Request.new(@client, request_method, path, options).perform
  end

  # statusからdisplay_name, username, contentを取得するメソッド
  def extract_from_status(status)
    account = status.account
    content = status.content

    # idの更新
    @ltl_since = status.id if @ltl_since < status.id

    # display_nameを取得する方法がattributesから直接引っ張ってくるしかなかった
    display = account.attributes["display_name"]
    display ||= account.acct
    { id: account.id, display: display, username: account.acct, content: content_convert(content) }
  end

  # HTMLタグを削除したり、改行コードを改行に変化させるメソッド
  def content_convert(content)
    content.gsub!("<br \/>", "\n")
    remove_tag(content)
  end

  def remove_tag(str)
    str.gsub(/<([^>]+)>/, "")
  end
end
