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
      @detection_thread = create_thread(:name_change_detection, 5)
      @detection_thread.join
      @reaction_thread = create_thread(:reaction_mention, 2)
      @reaction_thread.join
      @debug_thread = create_thread(:debug, 0)
      @debug_thread.join
    end

    def create_thread(method, sleep_time)
      Thread.new do
        loop do
          sleep(sleep_time) unless sleep_time.zero?
          send method
        end
      end
    end

    def stop
      @detection_thread.kill
      @reaction_thread.kill
      @debug_thread.kill
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
