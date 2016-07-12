# frozen_string_literal: true

require 'memo/parsing'

describe Parsing do
  file1 = <<-MARKDOWN
one
two
# headline1A
three
## headline2A
four
## headline2B

#headline1B
  MARKDOWN

  it 'process' do
    file_path = FilePath.new(nil)
    parsing = Parsing.new(file_path, file1)
    mfile = parsing.process
    expect(mfile.file_path).to equal file_path
    expect(mfile.description.lines).to eq %W(one\n two\n)
    expect(mfile.children[0].title.title_str).to eq 'headline1A'
    expect(mfile.children[0].description.lines).to eq ["three\n"]
    expect(mfile.children[0].children[0].title.title_str).to eq 'headline2A'
    expect(mfile.children[0].children[0].description.lines).to eq ["four\n"]
    expect(mfile.children[0].children[1].title.title_str).to eq 'headline2B'
    expect(mfile.children[0].children[1].description.lines).to eq ["\n"]
    expect(mfile.children[1].title.title_str).to eq 'headline1B'
  end
end
