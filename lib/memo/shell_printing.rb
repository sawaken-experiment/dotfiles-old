# frozen_string_literal: true

require 'memo/indent_out'

class ShellPrinting
  def initialize(search_result, query)
    @search_result = search_result
    @view_setting = query.view_setting
    @cond = query.cond
  end

  def show(out)
    show_content(IndentOut.new(out), true, @search_result, 1, 1)
  end

  def file_names
    path_strs = []
    @search_result.delegations.reject(&:empty?).each_with_index do |e, idx|
      next if @view_setting.index && idx + 1 != @view_setting.index
      path_strs << e.element.file_path.path_str
    end
    path_strs
  end

  private

  def show_content(out, is_top, search_result, pos, num)
    search_result.element.shell_header(out, pos, num, @cond)
    unless @view_setting.brief
      search_result.element.shell_description(out, @cond)
    end
    return if search_result.hit?
    non_empty_delegations = search_result.delegations.reject(&:empty?)
    non_empty_delegations.each_with_index do |ch, idx|
      next if is_top && @view_setting.index && idx + 1 != @view_setting.index
      show_content(out.inc, false, ch, idx + 1, non_empty_delegations.size)
    end
  end
end
