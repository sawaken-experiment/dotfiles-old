# frozen_string_literal: true

class Parsing
  def initialize(file_path, file_content)
    @file_path = file_path
    @lines = file_content.lines
  end

  def process
    description = parse_description
    children = []
    mfile = MarkdownFile.new(@file_path, description, children)
    while (child_section = parse_section(mfile, 1))
      children << child_section
    end
    mfile
  end

  private

  def parse_description
    pos = @lines.index { |line| headline?(line) }
    Description.new(@lines.shift(pos || @lines.size))
  end

  def parse_section(parent, min_depth)
    return nil if @lines.empty?
    raise 'first line should be headline' unless headline?(@lines.first)
    return nil unless headline_depth(@lines.first) >= min_depth
    headline = @lines.shift
    title = Title.new(headline_title(headline), headline_depth(headline))
    description = parse_description
    children = []
    section = Section.new(title, description, children, parent)
    while (child_section = parse_section(section, title.depth + 1))
      children << child_section
    end
    section
  end

  def headline_title(headline)
    headline.match(/^#+(.+)$/) do |m|
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
    line =~ /^#/
  end
end

class Condition
  def initialize(patterns)
    @patterns = patterns
  end

  def attack(matchable)
    Condition.new(@patterns.reject { |pat| matchable.match?(pat) })
  end

  def mark(text, head, tail)
    @patterns.reduce(text) { |a, e| a.gsub(e, head + '\&' + tail) }
  end

  def complete?
    @patterns.empty?
  end
end

class SearchTargetFlag
  attr_reader :file_path, :title, :description

  def initialize(file_path: true, title: true, description: true)
    @file_path = file_path
    @title = title
    @description = description
  end
end

class MarkdownFile
  attr_reader :file_path

  def initialize(file_path, description, children)
    @file_path = file_path
    @description = description
    @children = children
  end

  def search(cond, stf)
    cond = cond.attack(@file_path) if stf.file_path
    cond = cond.attack(@description) if stf.description
    if cond.complete?
      [self]
    else
      @children.map { |c| c.search(cond, stf) }.flatten
    end
  end

  def shell_render(out, cond)

  end
end

class Section
  def initialize(title, description, children, parent)
    @title = title
    @description = description
    @children = children
    @parent = parent
  end

  def search(cond, stf)
    cond = cond.attack(@title) if stf.title
    cond = cond.attack(@description) if stf.description
    if cond.complete?
      [self]
    else
      @children.map { |c| c.search(cond, stf) }.flatten
    end
  end

  def file_path
    @parent.file_path
  end

  def shell_render

  end
end

class FilePath
  def initialize(path_str)
    @path_str = path_str
  end

  def match?(pattern)
    @path_str.match(pattern)
  end

  def shell_render

  end
end

class Title
  attr_reader :depth

  def initialize(title_str, depth)
    @title_str = title_str
    @depth = depth
  end

  def match?(pattern)
    @title_str.match(pattern)
  end

  def shell_render(out)
    out.puts @title_str.chomp
  end
end

class Description
  def initialize(lines)
    @lines = lines
  end

  def match?(pattern)
    @lines.any? { |line| line.match(pattern) }
  end

  def shell_render(out)
    @lines.each do |line|
      out.puts line.chomp
    end
  end
end

class IndentOut
  def initialize(out, indent = 0)
    @out = out
    @indent = indent
  end

  def puts(str, color)
    @out.puts('  ' * @indent + str)
  end

  def print(str, color)
    @out.print("")
  end

  def indent
    @out.print('  ' * @indent)
  end

  def inc
    IndentOut.new(@out, @indent + 1)
  end
end

cond = Condition.new(%w(hoge piyo))
stf = SearchTargetFlag.new

MemorandumDirPath = File.expand_path(ENV['HOME'] + '/.memorandum')
markdown_files = Dir.glob(MemorandumDirPath + '/**/*.md').map do |file|
  file_path = FilePath.new(file)
  begin
    Parsing.new(file_path, open(file, 'r').read).process
  rescue => err
    puts 'parsing: ' + file
    raise err
  end
end

p markdown_files.size
hit = markdown_files.map { |mfile| mfile.search(cond, stf) }.flatten

hit.group_by(&:file_path).each do |file_path, sections|
  p file_path
  p sections.size
end
