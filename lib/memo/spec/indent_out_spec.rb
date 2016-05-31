# frozen_string_literal: true

require_relative '../indent_out.rb'

describe IndentOut do
  it 'inc' do
    require 'stringio'
    out = StringIO.new('', 'r+')
    indent_out = IndentOut.new(out, 0)
    indent_out.puts('one')
    indent_out.inc.puts('two')
    indent_out.puts('three')
    expect(out.string).to eq "one\n  two\nthree\n"
  end
end
