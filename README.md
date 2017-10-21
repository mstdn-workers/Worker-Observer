# <ruby>Name Change Detection<rp>（</rp><rt>名前変更検知プログラム</rt><rp>）</rp></ruby>
その名の通り、[(労働者のための)マストドン](https://mstdn-workers.com/about)でのあまりにも多い名前変更とそれを周知する術のなさが生み出した現代における監視プログラム。

### Contribute
労働者のためのマスト丼hubユーザーの方は自由に書き換えてください。

``` shell
$ git clone https://github.com/mstdn-workers/NameChangeDetection
$ cd NameChangeDetection
$ bundle install --path vendor/bundle
$ sqlite3 name_change_detection.db < create_table.sqlite
You write perfect and beautiful Code.
$ git push origin develop(, feature, or your-branch)
```

##### ちなみに
~~まだ名前変更検知っぽいことはしてません。~~  
DBにLTLの情報を読み取って名前などを流す機構ができました。

### やりたいこと
- [x] databaseのmigrationをrakeで自動化(mysqlでは完了)
- [ ] PostgreSQLの使用
- [ ] MastodonのOauth機能を使ったログイン機能
- [ ] BootStrapの使用
- [ ] Vueを使ったAjaxの使用
- [ ] 他、監視機能の追加