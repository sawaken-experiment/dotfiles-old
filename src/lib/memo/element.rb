# frozen_string_literal: true

class MarkdownFileList
  attr_reader :children

  def initialize(children)
    @children = children
  end

  def search(cond)
    SearchResult.new(self, @children.map { |c| c.search(cond) })
  end

  def shell_header(_out, _number, _cond)
    nil
  end

  def shell_description(_out, _cond)
    nil
  end
end

class MarkdownFile
  attr_reader :file_path, :description, :children

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

  def shell_header(out, number, cond)
    path = cond.mark(@file_path.path_str, "\e[36;4m", "\e[m\e[36m")
    out.puts "\e[36m#{number} #{path}\e[m"
  end

  def shell_description(out, cond)
    @description.shell_render(out, cond)
  end
end

class Section
  attr_reader :title, :description, :children
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

  def shell_header(out, number, cond)
    title = cond.mark(@title.title_str, "\e[33;4m", "\e[m\e[33m")
    out.puts "\e[33m#{'#' * @title.depth}#{number} #{title}\e[m"
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
        line = cond.mark(line.chomp, "\e[32;4m", "\e[m\e[32m")
        out.puts "    \e[32m#{line}\e[m"
      else
        line = cond.mark(line.chomp, "\e[4m", "\e[m")
        out.puts line
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
end
