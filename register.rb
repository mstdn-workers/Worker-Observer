# coding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'mastodon'
require 'readline'

require 'json'

APP_NAME = "Name Change Detecter"
DEFAULT_CONFIG = {
  "host" => "mstdn-workers.com",
  "scopes" => "read write",
}
TOKEN_FILE_NAME = '.access_token'
DEFAULT_CONFIG_FILE_NAME = 'config.json'
