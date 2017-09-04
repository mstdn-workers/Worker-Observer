require 'rubygems'
require 'active_record'
require 'sqlite3'

# データベースへの接続
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  'name_change_detection.db'
)

class Accounts < ActiveRecord::Base
end

class Names < ActiveRecord::Base
end

# データベース接続クラス
module NameChangeDetection
  class Database
    # Accountテーブルに新たな要素を作るメソッド。作成時にはnicknameが登録されることはない
    def register_account(id, username)
      Accounts.find_or_create_by(id: id) { |a| a.username = username }
    end

    def set_nickname(id, nickname)
      account = Accounts.find_by(id: id)
      account.update(nickname: nickname) unless account.nil?
    end

    # @param element[:id] = id
    # @param element[:username] = acct
    def accounts(element = nil)
      if element.nil?
        Accounts.order("id DESC")
      elsif element[:id]
        Accounts.where(id: element[:id])
      elsif element[:username]
        Accounts.where(username: element[:username])
      else
        Accounts.all
      end
    end

    def register_name(account_id, display)
      # 最新と同じ名前の場合何もしない
      newest = names(account_id).find_by(account_id: account_id)
      return if newest && display == newest.display_name
      puts "new_name: #{display}"

      name = Names.new do |n|
        time = Time.now.strftime("%Y/%m/%d %H:%M:%S")
        n.account_id = account_id
        n.display_name = display
        n.changed_date = time
        n.is_first = exist?(account_id) ? 0 : 1
      end
      name.save

      puts "complete register"
    end

    def names(id = nil)
      if id
        Names.order("id DESC").where(account_id: id)
      else
        Names.order("id DESC").all
      end
    end

    private

    def exist?(id)
      !Names.find_by(account_id: id).nil?
    end
  end
end
