# <ruby>Worker-Observer<rp>（</rp><rt>社畜監視マシン</rt><rp>）</rp></ruby>
その名の通り、[(労働者のための)マストドン](https://mstdn-workers.com/about)でのあまりにも多い名前変更とそれを周知する術のなさが生み出した現代における監視プログラム。
[(こいつ)https://github.com/mstdn-workers/NameChangeDetection]の強化版の予定。

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
- [ ] herokuでの正常稼働
- [ ] MastodonのOauth機能を使ったログイン機能
- [ ] BootStrapの使用
- [ ] Vueの使用
- [ ] Ajaxを使用して、強そうなやつを作りたい(願望)
- [ ] 他、監視機能の追加
