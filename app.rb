require 'sinatra'
require 'slim'

require './database._b'
# apiのルーティングを追加
require './api.rb'

get '/' do
  slim :index
end
