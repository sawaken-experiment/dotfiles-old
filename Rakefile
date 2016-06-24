# frozen_string_literal: true
# ----------------------------------------------------------------------
# 環境構築スクリプト集
# 利用者へ:
#   - ビルドツールとRakeの実行環境が必要.
# 開発者へ:
#   - 冪等性(=同じタスクを何回実行しても実行後の状態は同一)を満たすようにタスクを定義すること.
#   - 一貫性(=以下のようなpath1とpath2の結果は常に同一)を満たすようにタスクを定義すること.
#       path1: taskAを実行 -> 正常終了
#       path2: taskAを実行 -> 異常終了 -> 原因を除去 -> taskAを実行 -> 正常終了
# ----------------------------------------------------------------------

$LOAD_PATH.unshift File.expand_path('../src/lib', __FILE__)

require 'setup/util'
require 'setup/layer'
require 'setup/task/common'
require 'setup/task/osx'
require 'setup/task/debian'
require 'setup/task/centos'
require 'setup/task/cygwin'
require 'setup/task/command_prompt'

systems = {
  'darwin' => [CommonLayer, OSXLayer],
  'debian' => [CommonLayer, DebianLayer],
  'ubuntu' => [CommonLayer, DebianLayer],
  'centos' => [CommonLayer, CentOSLayer],
  'cygwin' => [CommonLayer, CygwinLayer],
  'command_prompt' => [CommandPromptLayer]
}

if ENV['system']
  name = ENV['system']
  raise "unknown system '#{name}'" unless systems.key?(name)
  activate(*systems[name])
elsif ENV['OS'] =~ /[Ww]indows/
  if (`uname` =~ /CYGWIN/ rescue false)
    puts 'Rakefile for Cygwin'
    activate(*systems['cygwin'])
  else
    puts 'Rakefile for Command Prompt'
    activate(*systems['command_prompt'])
  end
elsif `uname -a` =~ /[Dd]arwin/
  puts 'Rakefile for OSX'
  activate(*systems['darwin'])
elsif `uname -a` =~ /[Dd]ebian|[Uu]buntu/
  puts 'Rakefile for Debian 8.3 (or Ubuntu)'
  activate(*systems['debian'])
elsif `uname -a` =~ /[Cc]ent[Oo][Ss]/
  puts 'Rakefile for CentOS'
  activate(*systems['centos'])
else
  raise 'unsupported system'
end
