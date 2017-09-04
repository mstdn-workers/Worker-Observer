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
      @detection_thread = create_thread(:name_change_detection, 5)
      @reaction_thread = create_thread(:reaction_mention, 2)
      @debug_thread = create_thread(:debug, 0)
      @detection_thread.join
      @reaction_thread.join
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
        display = status[:display]
        display ||= status[:acct]
        @database.register_name(status[:id], display)
      end
    end

    # mentionに合わせてtootをリプライするメソッド
    def reaction_mention
      @manager.notifications.each do |notifications|
        # リプライ以外を弾く
        next unless notifications["type"] == "mention"

        toot_id = notifications["status"]["id"]
        replay_account_id = notifications["status"]["account"]["id"]
        replay_account = notifications["status"]["account"]["username"]
        content = @manager.content_convert(notifications["status"]["content"])

        send(select_method(content), toot_id, replay_account, replay_account_id, content)
      end
    end

    def select_method(content)
      case content
      when /nickname/
        :set_nickname
      when /help/
        :puts_help
      else
        :react_normal
      end
    end

    def set_nickname(toot_id, replay_account, account_id, content)
      nickname = content.match(/nickname\s*(\S*)/)[1]
      @database.set_nickname(account_id, nickname)
      @manager.toot("@#{replay_account} ニックネームを#{nickname}に設定しました。", "direct", toot_id)
    end

    def puts_help(toot_id, replay_account, _, _)
      help = <<~EOF
        @#{replay_account}
        ヘルプ一覧
        nickname 任意の名前: 入力された任意の名前を自分のニックネームとして凍露します。
        help : ヘルプ一覧を表示します。
      EOF
      @manager.toot(help, "direct", toot_id)
    end

    def react_normal(toot_id, replay_account, account_id, content)

    end

    def debug
      puts "debug"
      # debug用のメソッドは"d_"というprefixをつけるため
      command = gets.chomp
      arg = command.split[1]
      command = ("d_" + command.split[0]).to_sym
      respond_to?(command, true) ? send(command, arg) : d_help(nil)
    end

    # debug用コマンド

    def d_help(_)
      puts "デバッグ時のコマンド一覧"

      # (privateな)methodのうちd_から始まるデバッグ用のメソッドをd_を消して表示する
      Main.private_instance_methods(false).each do |method|
        puts method.to_s.delete("d_") if method.to_s.start_with?("d_")
      end
      puts
    end

    def d_start(_)
      stop
      start
    end

    def d_stop(_)
      stop_without_debug
    end

    def d_all_stop
      stop
    end

    def d_accounts(arg)
      puts "id\tusername\tnickname"
      i = 0
      @database.accounts(username: arg).each do |account|
        puts "#{account.id}\t#{account.username}\t#{account.nickname}"
        i += 1
        break if i >= 10
      end
      puts
    end

    def d_names(arg)
      puts "id\tdisplay_name\tchanged_date"
      i = 0
      arg = arg.to_i if arg
      @database.names(arg).each do |name|
        puts "#{name.account_id}\t#{name.display_name}\t#{name.changed_date}"
        i += 1
        break if i >= 10
      end
      puts
    end

    def stop_without_debug
      @detection_thread.kill
      @reaction_thread.kill
    end
  end
end

NameChangeDetection::Main.new.start
