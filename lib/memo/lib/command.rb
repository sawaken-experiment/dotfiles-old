# frozen_string_literal: true

require 'memo/lib/indent_out'
require 'memo/lib/condition'

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

class ShellPrinting
  def initialize(search_result, query)
    unless search_result.element.is_a?(MarkdownFileList)
      raise ArgumentError, "not a MarkdownFileList: #{search_result}"
    end
    @search_result = search_result
    @view_setting = query.view_setting
    @cond = query.cond
  end

  def show
    if @view_setting.editor
      open_by_editor(@view_setting.editor)
      return
    end
    if @view_setting.stdout
      show_content(IndentOut.new(STDOUT), @search_result, 1, 1)
    else
      require 'tempfile'
      Tempfile.open(['result', '.md']) do |f|
        show_content(IndentOut.new(f), @search_result, 1, 1)
        f.flush
        system("less -fr #{f.path}")
      end
    end
  end

  private

  def open_by_editor(editor_name)
    path_strs = []
    @search_result.delegations.reject(&:empty?).each_with_index do |e, idx|
      next if @view_setting.index && idx + 1 != @view_setting.index
      path_strs << e.element.file_path.path_str
    end
    system("#{editor_name} #{path_strs.join(' ')}")
  end

  def show_content(out, search_result, pos, num)
    search_result.element.shell_header(out, pos, num, @cond)
    unless @view_setting.brief
      search_result.element.shell_description(out, @cond)
    end
    return if search_result.hit?
    non_empty_delegations = search_result.delegations.reject(&:empty?)
    non_empty_delegations.each_with_index do |ch, idx|
      if search_result.element.is_a?(MarkdownFileList)
        next if @view_setting.index && idx + 1 != @view_setting.index
      end
      show_content(out.inc, ch, idx + 1, non_empty_delegations.size)
    end
  end
end
