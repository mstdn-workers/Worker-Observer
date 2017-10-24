# <ruby>Name Change Detection<rp>（</rp><rt>名前変更検知プログラム</rt><rp>）</rp></ruby>
その名の通り、[(労働者のための)マストドン](https://mstdn-workers.com/about)でのあまりにも多い名前変更とそれを周知する術のなさが生み出した現代における監視プログラム。

### Contribute
労働者のためのマスト丼hubユーザーの方は自由に書き換えてください。

``` shell
$ git clone https://github.com/mstdn-workers/NameChangeDetection
$ cd NameChangeDetection
$ bundle install --path vendor/bundle
$ psql -U postgres
# You create new database(and create user if you need)

<<<<<<< HEAD
$ emacs(or your editor) ~/.zshrc (or your shell run command file)
=======
$ emacs(or your editor) config/secret.yml
>>>>>>> front
# Write it.
# username: <Your PostgreSQL username>
# password: <Your PostgreSQL password>
# database: <Your PostgreSQL database name>

$ bundle exec rake ENV=development
# You write perfect and beautiful Code.

$ git push origin develop(, feature, or your-branch)
```

##### ちなみに
~~まだ名前変更検知っぽいことはしてません。~~  
DBにLTLの情報を読み取って名前などを流す機構ができました。

### やりたいこと
- [x] databaseのmigrationをrakeで自動化
- [x] PostgreSQLの使用
- [ ] MastodonのOauth機能を使ったログイン機能
- [ ] BootStrapの使用
- [ ] Vueの使用
- [ ] Ajaxを使用して、強そうなやつを作りたい(願望)
- [ ] 他、監視機能の追加
