require 'sinatra'
require 'slim'

require './database.rb'
# apiのルーティングを追加
require './api.rb'

get "/" do
  slim :index
end
