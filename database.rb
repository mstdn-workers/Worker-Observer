require 'rubygems'
require 'active_record'
require 'singleton'
require "yaml"
require "erb"

# データベースへの接続
config = YAML.safe_load(ERB.new(File.read("./config/database.yml")).result)
ActiveRecord::Base.establish_connection(config["db"]["production"])

Time.zone = 'Tokyo'
Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord::Base.default_timezone = :local

class Accounts < ActiveRecord::Base
  has_many :names
end

class Names < ActiveRecord::Base
  belongs_to :account
end

# データベース接続クラス
module NameChangeDetection
  class Database
    include Singleton
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
        n.account_id = account_id
        n.display_name = display
        n.is_first = exist?(account_id) ? 0 : 1
      end
      name.save

      puts "complete register"
    end

    # @param element[:id] = id
    # @param element[:username] = acct
    def names(element = nil)
      if element.nil?
        Names.joins(:accounts).order("id DESC").all
      elsif element[:id]
        Names.joins(:accounts).order("id DESC").where(account_id: element[:id])
      elsif element[:username]
        Names.joins(:accounts).order("id DESC").where(username: element[:username])
      else
        Names.joins(:accounts).order("id DESC").all
      end
    end

    private

    def exist?(id)
      !Names.find_by(account_id: id).nil?
    end
  end
end
