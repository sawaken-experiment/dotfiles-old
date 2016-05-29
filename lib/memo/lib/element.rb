# frozen_string_literal: true

class MarkdownFileList
  def initialize(children)
    @children = children
  end

  def search(cond)
    SearchResult.new(self, @children.map { |c| c.search(cond) })
  end

  def shell_header(_out, _pos, _num, _cond)
    nil
  end

  def shell_description(_out, _cond)
    nil
  end
end

class MarkdownFile
  attr_reader :file_path

  def initialize(file_path, description, children)
    @file_path = file_path
    @description = description
    @children = children
  end

  def search(cond)
    cond = cond.attack(@file_path) if cond.stf.file_path
    cond = cond.attack(@description) if cond.stf.description
    if cond.complete?
      SearchResult.new(self)
    else
      SearchResult.new(self, @children.map { |c| c.search(cond) })
    end
  end

  def shell_header(out, pos, num, cond)
    out.puts "\e[36m[#{pos}/#{num}] #{@file_path.path_str}\e[m"
  end

  def shell_description(out, cond)
    @description.shell_render(out, cond)
  end
end

class Section
  attr_reader :title
  def initialize(title, description, children)
    @title = title
    @description = description
    @children = children
  end

  def search(cond)
    cond = cond.attack(@title) if cond.stf.title
    cond = cond.attack(@description) if cond.stf.description
    if cond.complete?
      SearchResult.new(self)
    else
      SearchResult.new(self, @children.map { |c| c.search(cond) })
    end
  end

  def shell_header(out, pos, num, cond)
    out.puts "\e[33m#{'#' * @title.depth}[#{pos}/#{num}] #{@title.title_str}\e[m"
  end

  def shell_description(out, cond)
    @description.shell_render(out, cond)
  end
end

class FilePath
  attr_reader :path_str

  def initialize(path_str)
    @path_str = path_str
  end

  def match?(pattern)
    @path_str.match(pattern)
  end
end

class Title
  attr_reader :title_str, :depth

  def initialize(title_str, depth)
    @title_str = title_str
    @depth = depth
  end

  def match?(pattern)
    @title_str.match(pattern)
  end
end

class Description
  attr_reader :lines

  def initialize(lines)
    @lines = lines
  end

  def match?(pattern)
    @lines.any? { |line| line.match(pattern) }
  end

  def shell_render(out, cond)
    count = 0
    @lines.each do |line|
      if line =~ /^```/
        count += 1
        next
      end
      if count.odd?
        out.puts "    \e[32m#{line.chomp}\e[m"
      else
        out.puts "#{line.chomp}"
      end
    end
  end
end

class SearchResult
  attr_reader :element, :delegations

  def initialize(element, delegations = nil)
    @element = element
    @delegations = delegations
  end

  def hit?
    @delegations.nil?
  end

  def empty?
    !hit? && @delegations.all?(&:empty?)
  end

  def shell_render(out, query)
    @element.shell_render(out, query)
  end
end
