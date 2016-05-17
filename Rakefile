# ------------------------------
# 環境構築スクリプト集
# 利用者へ:
#   - ビルドツールとRakeの実行環境が必要.
# 開発者へ:
#   - 冪等性(=同じタスクを何回実行しても実行後の状態は同一)を満たすようにタスクを定義すること.
#   - 一貫性(=以下のようなpath1とpath2の結果は常に同一)を満たすようにタスクを定義すること.
#       path1: taskAを実行 -> 正常終了
#       path2: taskAを実行 -> 異常終了 -> 原因を除去 -> taskAを実行 -> 正常終了
# ------------------------------

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'setup/util'
require 'setup/task/common'
require 'setup/task/osx'
require 'setup/task/debian'

case `uname -a`
when /Darwin/
  activate(:osx)
when /debian/, /ubuntu/
  activate(:debian)
when /centos/
  activate(:centos)
else
  raise 'unsupported OS'
end
