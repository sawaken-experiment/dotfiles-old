# frozen_string_literal: true

class IndentOut
  def initialize(out, indent = 0)
    @out = out
    @indent = indent
  end

  def puts(str)
    @out.puts(('  ' * @indent) + str)
  end

  def print(str)
    @out.print(str)
  end

  def inc
    IndentOut.new(@out, @indent + 1)
  end
end
