require './database'

# 今回のメイン機能を実装したクラス
class NameChangeDetection
  # Accountテーブルに新たな要素を作るメソッド。作成時にはnicknameが登録されることはない
  def register_account(id, username)
    Accounts.find_or_create_by(id: id) { |a| a.username = username }
  end

  def set_nickname(id, nickname)
    account = Accounts.find_by(id: id)
    account.update(nickname: nickname) unless account.nil?
  end

  def register_name(account_id, display)
    Names.find_or_create_by(account_id: account_id, display_name: display) do |n|
      time = Time.now.strftime("%Y/%m/%d %H:%M:%S")
      n.changed_date = time
      n.is_first = exist?(account_id) ? 0 : 1
    end
    p Names.all
  end

  def exist?(id)
    !Names.find_by(account_id: id).nil?
  end
end
