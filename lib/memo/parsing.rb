# frozen_string_literal: true

require 'memo/element'

class Parsing
  def initialize(file_path, file_content)
    @file_path = file_path
    @lines = file_content.lines
  end

  def process
    description = parse_description
    children = []
    mfile = MarkdownFile.new(@file_path, description, children)
    while (child_section = parse_section(1))
      children << child_section
    end
    mfile
  end

  private

  def parse_description
    pos = headline_pos(@lines)
    Description.new(@lines.shift(pos || @lines.size))
  end

  def parse_section(min_depth)
    return nil if @lines.empty?
    raise 'first line should be headline' unless headline?(@lines.first)
    return nil unless headline_depth(@lines.first) >= min_depth
    headline = @lines.shift
    title = Title.new(headline_title(headline), headline_depth(headline))
    description = parse_description
    children = []
    while (child_section = parse_section(title.depth + 1))
      children << child_section
    end
    Section.new(title, description, children)
  end

  def headline_title(headline)
    headline.match(/^#+(.*)$/) do |m|
      return m[1].strip
    end
    raise "not headline: #{headline}"
  end

  def headline_depth(headline)
    headline.match(/^#+/) do |m|
      return m[0].length
    end
    raise "not headline: #{headline}"
  end

  def headline?(line)
    line[0] == '#'
  end

  def headline_pos(lines)
    count = 0
    lines.each_with_index do |line, idx|
      count += 1 if line =~ /^```/
      return idx if headline?(line) && count.even?
    end
    nil
  end
end
