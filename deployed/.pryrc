# -*- mode: ruby -*-

# コマンドのプレフィックス指定
Pry.config.command_prefix = "%"

# プロンプトにバージョンを表示
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
