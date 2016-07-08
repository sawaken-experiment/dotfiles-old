# -*- mode: ruby -*-

# ----------------------------------------------------------------------
# コマンド設定
# ----------------------------------------------------------------------

# プレフィックス指定
#Pry.config.command_prefix = "%"

# alias w => whereami
Pry.config.commands.alias_command 'w', 'whereami'

# ----------------------------------------------------------------------
# プロンプト設定
#   - Rubyのバージョン情報を表示
# ----------------------------------------------------------------------

Pry.config.prompt = [
  # 通常時のプロンプト
  proc do |target_self, nest_level, pry|
    nested = nest_level.zero? ? '' : ":#{nest_level}"
    "[#{pry.input_array.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}> "
  end,
  # 入力継続時のプロンプト
  proc do |target_self, nest_level, pry|
    nested = nest_level.zero? ? '' : ":#{nest_level}"
    "[#{pry.input_array.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}* "
  end
]

# ----------------------------------------------------------------------
# pry-byebug設定
# ----------------------------------------------------------------------

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end
# Hit Enter to repeat last command
Pry::Commands.command(/^$/, "repeat last command") do
  _pry_.run_command Pry.history.to_a.last
end

# ----------------------------------------------------------------------
# awesome_printがインストールされていたら、オブジェクト表示にawesome_printを使う
# ----------------------------------------------------------------------

begin
  require 'awesome_print'
rescue LoadError
  nil
else
  AwesomePrint.pry!
end
