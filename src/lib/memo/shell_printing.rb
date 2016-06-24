# frozen_string_literal: true

require 'memo/indent_out'
require 'memo/element'

class ShellPrinting
  def initialize(search_result, query)
    unless search_result.element.is_a?(MarkdownFileList)
      raise 'search_result should be a MarkdownFileList'
    end
    @search_result = search_result
    @view_setting = query.view_setting
    @cond = query.cond
  end

  def show(out)
    show_content(IndentOut.new(out), true, @search_result, '')
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

  def show_content(out, is_top, search_result, number)
    search_result.element.shell_header(out, number, @cond)
    unless @view_setting.brief
      search_result.element.shell_description(out, @cond)
      if search_result.hit?
        search_result.element.children.each do |c|
          show_element(out.inc, c)
        end
      end
    end
    return if search_result.hit?
    non_empty_delegations = search_result.delegations.reject(&:empty?)
    non_empty_delegations.each_with_index do |ch, idx|
      next if is_top && @view_setting.index && idx + 1 != @view_setting.index
      number = "#{idx + 1}/#{non_empty_delegations.size}"
      show_content(out.inc, false, ch, "[#{number}]")
    end
  end

  def show_element(out, element)
    element.shell_header(out, '[*]', @cond)
    element.shell_description(out, @cond)
    element.children.each do |c|
      show_element(out.inc, c)
    end
  end
end
