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
end
