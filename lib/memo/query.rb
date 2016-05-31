# frozen_string_literal: true

require 'memo/condition'

class Query
  attr_reader :view_setting, :cond

  def initialize(argv)
    require 'optparse'
    @view_setting = ViewSetting.new
    stf = SearchTargetFlag.new
    use_regexp = false
    opt_parser = OptionParser.new do |op|
      op.on('-s', '検索結果を標準出力に表示') do |v|
        @view_setting.stdout = v
      end
      op.on('-i INDEX', 'INDEX番目にヒットしたファイルのみを表示する') do |v|
        @view_setting.index = v.to_i
      end
      op.on('-e [EDITOR]', 'ヒットしたファイルを直接EDITORで開く') do |v|
        @view_setting.editor = v || ENV['EDITOR']
      end
      op.on('-b', '見出しのみを出力') do |v|
        @view_setting.brief = v
      end
      op.on('-r', '検索ワードを正規表現として扱う') do
        use_regexp = true
      end
      op.on('--[no-]path', '検索対象にパスを含める(デフォルト)') do |v|
        stf.file_path = v
      end
      op.on('--[no-]title', '検索対象にタイトルを含める(デフォルト)') do |v|
        stf.title = v
      end
      op.on('--[no-]desc', '検索対象に内部記述を含める(デフォルト)') do |v|
        stf.description = v
      end
    end
    @cond = Condition.new(
      opt_parser.parse(argv).map { |w| use_regexp ? Regexp.new(w) : w },
      stf
    )
  end

  class ViewSetting
    attr_accessor :stdout, :index, :editor, :brief

    def initialize(stdout: false, index: nil, editor: nil, brief: false)
      @stdout = stdout
      @index = index
      @editor = editor
      @brief = brief
    end
  end
end
