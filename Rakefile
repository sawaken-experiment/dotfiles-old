# ------------------------------
# 環境構築スクリプト集
# 利用者へ:
#   - ビルドツールとRakeの実行環境が必要. 先にinit.shを実行しておくこと.
# 開発者へ:
#   - 冪等性(=同じタスクを何回実行しても実行後の状態は同一)を満たすようにタスクを定義すること.
#   - 一貫性(=以下のようなpath1とpath2の結果は常に同一)を満たすようにタスクを定義すること.
#       path1: taskAを実行 -> 正常終了
#       path2: taskAを実行 -> 異常終了 -> 原因を除去 -> taskAを実行 -> 正常終了
#   - Rakefile一般に関するメモ:
#     - ruleのdepsにrule以外を指定しないこと. 差分ビルドが意味を為さなくなる.
# ------------------------------

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'setup/util'
require 'setup/task/common'
require 'setup/task/osx'
require 'setup/task/test'

desc 'OSXの環境を構築'
task 'setup-osx' do

end

desc 'Debianの環境を構築'
task 'setup-debian' do

end

desc 'CentOSの環境を構築'
task 'setup-centos' do

end
