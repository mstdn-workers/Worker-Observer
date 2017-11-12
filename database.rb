require 'rubygems'
require 'active_record'
require 'singleton'
require "yaml"
require "erb"
require 'date'

# データベースへの接続
config = YAML.safe_load(ERB.new(File.read("./config/database.yml")).result)
ActiveRecord::Base.establish_connection(config["db"]["development"])

Time.zone = 'Tokyo'
Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord::Base.default_timezone = :local

class Account < ActiveRecord::Base
  has_many :names
  has_many :toot_counts
end

class Name < ActiveRecord::Base
  belongs_to :account
end

class TootCount < ActiveRecord::Base
  belongs_to :account
end

# データベース接続クラス
module NameChangeDetection
  class Database
    include Singleton
    # Accountテーブルに新たな要素を作るメソッド。作成時にはnicknameが登録されることはない
    def register_account(id, username)
      Account.find_or_create_by(id: id) { |a| a.username = username }
    end

    def set_nickname(id, nickname)
      account = Account.find_by(id: id)
      account.update(nickname: nickname) unless account.nil?
    end

    # @param element[:id] = id
    # @param element[:username] = acct
    def accounts(element = nil)
      if element.nil?
        Account.order("id DESC")
      elsif element[:id]
        Account.where(id: element[:id])
      elsif element[:username]
        Account.where(username: element[:username])
      else
        Account.all
      end
    end

    def register_name(account_id, display)
      # 最新と同じ名前の場合何もしない
      newest = names(id: account_id).find_by(account_id: account_id)
      return if newest && display == newest.display_name
      puts "new_name: #{display}"

      account = Account.find(account_id)
      account.names.create do |n|
        n.account_id = account_id
        n.display_name = display
        n.is_first = exist?(account_id) ? 0 : 1
      end

      puts "complete register"
    end

    def count_toot(status)
      return unless exist?(status[:id])
      toot_counts = TootCount.joins(:account).select("toot_counts.*, accounts.username").order("toot_counts.created_at DESC")
      toot_count = toot_counts.all.where(account_id: status[:id]).first

      created_at = Date.parse(toot_count.created_at.to_s) unless toot_count.nil?

      # toot_countがnilだった場合は単純に最初の登録
      if toot_count.nil? || toot_count.all_toot_num.nil?
        Account.find(status[:id]).toot_counts.create do |t|
          t.account_id = status[:id]
          t.toot_num_per_day = 0
          t.all_toot_num = status[:statuses_count]
        end
        # toot_countの日付が昨日以前であれば
      elsif !(Date.today - created_at).zero?
        Account.find(status[:id]).toot_counts.create do |t|
          t.account_id = status[:id]
          # tootしたタイミングだから-1を行う
          t.toot_num_per_day = status[:statuses_count] - toot_count.all_toot_num - 1
          t.all_toot_num = account.statuses_count
        end
      end

      # 31日前のやつを削除する
      last_count = toot_counts.all.where(account_id: status[:id]).last
      created_at = Date.parse(last_count.created_at.to_s) unless last_count.nil?

      last_count.delete if Date.today - created_at >= 31
    end

    # @param element[:username] = acct
    def toot_counts(element)
      username = element[:username]
      all_toot_counts = TootCount.joins(:account).select("toot_counts.*, accounts.username").order("created_at DESC").where("accounts.username = ?", username).all.references(:account)
      formated_data = []

      all_toot_counts.each do |count|
        created_at = Date.parse(count.created_at.to_s)
        days_ago = Date.today - created_at
        x = "#{days_ago.to_i} days ago"
        y = count.toot_num_per_day
        formated_data << { x: x, y: y } unless days_ago.zero?
      end

      format_data(formated_data)

      formated_data
    end

    # @param element[:id] = id
    # @param element[:username] = acct
    def names(element = nil)
      all_names = Name.joins(:account).select("names.*, accounts.username, accounts.nickname").order("names.id DESC")
      if element.nil?
        all_names.all
      elsif element[:id]
        all_names.all.where(account_id: element[:id])
      elsif element[:username]
        all_names.all.where("accounts.username like ?",
        "%" + sanitize_sql_like(element[:username]) + "%").references(:account)
      else
        all_names.all
      end
    end

    private

    def exist?(id)
      !Name.find_by(account_id: id).nil?
    end

    # sqlのLikeに関するサニタイズ(ActiveRecord::Sanitization::ClassMethodsにあるはずなんだけど...)
    def sanitize_sql_like(string)
      string.gsub("%", "\\%").gsub("_", "\\_")
    end

    def format_data(data)
      empty_days_ago = []
      1.upto 30 do |i|
        empty_days_ago << i
      end

      data.each do |d|
        # 12 days agoをto_iすると12が得られる
        empty_days_ago.delete(d[:x].to_i)
      end

      empty_days_ago.each do |i|
        data << { x: "#{i} days ago", y: 0 }
      end
    end
  end
end
