# frozen_string_literal: true

require 'memo/shell_printing'
require 'memo/query'
require 'memo/element'
require 'memo/parsing'

describe ShellPrinting do
  file1 = <<-MARKDOWN
# hoge
fuga
  MARKDOWN

  print1 = <<-TXT
  \e[36m[1/1] /markdown/file1.md\e[m
    \e[33m#[1/1] \e[33;4mhoge\e[m\e[33m\e[m
    fuga
  TXT

  q1 = Query.new(%w(hoge))
  fp1 = FilePath.new('/markdown/file1.md')

  before do
    require 'stringio'
    @out = StringIO.new('', 'r+')
  end

  it 'show' do
    r = MarkdownFileList.new([Parsing.new(fp1, file1).process]).search(q1.cond)
    ShellPrinting.new(r, q1).show(@out)
    expect(@out.string).to eq print1
  end

  it 'file_names' do
    r = MarkdownFileList.new([Parsing.new(fp1, file1).process]).search(q1.cond)
    expect(ShellPrinting.new(r, q1).file_names).to eq ['/markdown/file1.md']
  end
end
