# frozen_string_literal: true

class Condition
  attr_reader :patterns, :stf

  def initialize(patterns, stf)
    @patterns = patterns
    @stf = stf
  end

  def attack(matchable)
    Condition.new(@patterns.reject { |pat| matchable.match?(pat) }, @stf)
  end

  def mark(text, head, tail)
    @patterns.reduce(text) { |a, e| a.gsub(e, head + '\&' + tail) }
  end

  def complete?
    @patterns.empty?
  end
end

class SearchTargetFlag
  attr_accessor :file_path, :title, :description

  def initialize(file_path: true, title: true, description: true)
    @file_path = file_path
    @title = title
    @description = description
  end
end
