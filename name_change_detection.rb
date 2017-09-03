require './database'
require './simple_mastodon'

module NameChangeDetection
  # 今回のメイン機能を実装したクラス
  class Main
    def initialize
      @manager = SimpleMastodon.new
      @database = NameChangeDetection::Database.new
    end

    def start
      register_thread
    end

    # threadを追加するメソッド
    def register_thread
      ncd_thread = Thread.new do
        loop do
          sleep(5.0)
          name_change_detection
        end
      end
      ncd_thread.join

      rm_thread = Thread.new do
        loop do
          sleep(2.0)
          reaction_mention
        end
      end
      rm_thread.join

      debug_thread = Thread.new do
        loop do
          debug
        end
      end
      debug_thread.new
    end

    # 名前変更検知を行うメソッド
    def name_change_detection
      @manager.local_time_line.each do |status|
        @database.register_account(status[:id], status[:username])
        @database.register_name(status[:id], status[:display])
      end
    end

    # mentionに合わせてtootをリプライするメソッド
    def reaction_mention

    end

    def debug

    end
  end
end

NameChangeDetection::Main.new.start
