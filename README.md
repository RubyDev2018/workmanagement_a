# Ruby on Rails 
実行手順書

```
$ bundle install --without production
```

その後、データベースへのマイグレーションを実行

```
$ rails db:migrate
```

最後に、テストを実行してうまく動いているかどうか確認

```
$ rails test
```

テストが無事に通ったら、Railsサーバーを立ち上げる準備を行う

```
$ rails server
```