require 'rubygems'
require 'active_record'
require 'sqlite3'

# データベースへの接続
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  'name_change_detection.db'
)

class Accounts < ActiveRecord::Base
end

class Names < ActiveRecord::Base
end
