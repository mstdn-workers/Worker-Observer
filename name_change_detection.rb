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

    def stop
      @detection_thread.kill
      @reaction_thread.kill
      @debug_thread.kill
    end

    private

    # threadを追加するメソッド
    def register_thread
      #@detection_thread = create_thread(:name_change_detection, 5)
      #@detection_thread.join
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

    # 名前変更検知を行うメソッド
    def name_change_detection
      @manager.local_time_line.each do |status|
        @database.register_account(status[:id], status[:username])
        @database.register_name(status[:id], status[:display])
      end
    end

    # mentionに合わせてtootをリプライするメソッド
    def reaction_mention
      @manager.notifications.each do |notifications|
        # リプライ以外を弾く
        next unless notifications["type"] == "mention"

        toot_id = notifications["status"]["id"]
        reply_account = notifications["status"]["account"]["username"]
        content = notifications["status"]["content"]

        if content.include?("test")
          @manager.toot("@#{reply_account} test", "direct", toot_id)
        end
      end
    end

    def debug
      # debug用のメソッドは"d_"というprefixをつけるため
      command = ("d_" + gets.chomp).to_sym
      respond_to?(command) ? send(command) : d_help
    end

    # debug用コマンド

    def d_help
      puts "デバッグ時のコマンド一覧"
      methods.each do |method|
        puts method.to_s.delete("d_") if method.to_s.start_with?("d_")
      end
      puts
    end

    def d_start
      stop
      start
    end

    def d_stop
      stop_without_debug
    end

    def d_all_stop
      stop
    end

    def stop_without_debug
      @detection_thread.kill
      @reaction_thread.kill
    end
  end
end

NameChangeDetection::Main.new.start
