---
title: Rails Starter
description: A Rails starter app using a PostgreSQL database
tags:
  - ruby
  - rails
  - postgresql
  - railway.app
---

# 環境構築

```bash
$ git clone git@github.com:gonzaemon111/lagring.git
$ docker compose up -d
$ bundle install -j4
$ bundle exec rails db:create db:migrate
$ bin/rails s -p 3001
```
