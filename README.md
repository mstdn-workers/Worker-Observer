# <ruby>Worker-Observer<rp>（</rp><rt>社畜監視マシンAPI</rt><rp>）</rp></ruby>
その名の通り、[(労働者のための)マストドン](https://mstdn-workers.com/about)での監視を目的とした(適当)プログラム。APIを提供する(予定な)ので、実際にはブラウザなどで情報を表示するはず。
[こいつ](https://github.com/mstdn-workers/NameChangeDetection)の強化版の予定。

### Contribute
労働者のためのマスト丼hubユーザーの方は自由に書き換えてください。

``` shell
$ git clone https://github.com/mstdn-workers/NameChangeDetection
$ cd NameChangeDetection
$ bundle install --path vendor/bundle
$ psql -U postgres
# You create new database(and create user if you need)

$ emacs(or your editor) config/secret.yml
# Write it.
# username: <Your PostgreSQL username>
# password: <Your PostgreSQL password>
# database: <Your PostgreSQL database name>

$ bundle exec rake ENV=development
# You write perfect and beautiful Code.

$ git push origin develop(, feature, or your-branch)
$ sudo bundle exec thin start -p 80 -R config.ru
```


### やりたいこと
- [x] databaseのmigrationをrakeで自動化
- [x] PostgreSQLの使用
- [x] herokuでの正常稼働
- [ ] session_idを入出力するapi
