# frozen_string_literal: true

require 'memo/element'

describe 'element.rb' do
  describe MarkdownFileList do
    it 'search' do
      e = MarkdownFileList.new([])
      r = e.search(nil)
      expect(r.element).to equal e
      expect(r.delegations).to eq []
    end
  end

  describe MarkdownFile do
    it 'search' do
      file_path = FilePath.new('/markdown/hoge.md')
      desc = Description.new(%w(xxx yyy))
      mfile = MarkdownFile.new(file_path, desc, [])
      result1 = mfile.search(Condition.new(['down'], SearchTargetFlag.new))
      expect(result1.hit?).to be_truthy
      result2 = mfile.search(Condition.new(['up'], SearchTargetFlag.new))
      expect(result2.hit?).to be_falsey
    end

    it 'shell_header' do
      file_path = FilePath.new('/markdown/hoge.md')
      cond = Condition.new(['down'], nil)
      out = StringIO.new('', 'r+')
      MarkdownFile.new(file_path, nil, []).shell_header(out, 'X', cond)
      answer = eq "\e[36mX /mark\e[36;4mdown\e[m\e[36m/hoge.md\e[m\n"
      expect(out.string).to answer
    end
  end

  describe Section do
    it 'search' do
      title = Title.new('abcd', 1)
      desc = Description.new(%w(xxx yyy))
      sec = Section.new(title, desc, [])
      result1 = sec.search(Condition.new(['bc'], SearchTargetFlag.new))
      expect(result1.hit?).to be_truthy
      result2 = sec.search(Condition.new(['xy'], SearchTargetFlag.new))
      expect(result2.hit?).to be_falsey
    end

    it 'shell_header' do
      title = Title.new('title', 1)
      cond = Condition.new(['it'], nil)
      out = StringIO.new('', 'r+')
      Section.new(title, nil, []).shell_header(out, 'X', cond)
      expect(out.string).to eq "\e[33m#X t\e[33;4mit\e[m\e[33mle\e[m\n"
    end
  end

  describe FilePath do
    it 'match?' do
      t = Title.new('abcde', 1)
      expect(t.match?('cd')).to be_truthy
    end
  end

  describe Description do
    it 'match?' do
      d = Description.new(%w(ab cd))
      expect(d.match?('b')).to be_truthy
    end

    it 'shell_render' do
      require 'stringio'
      out = StringIO.new('', 'r+')
      d = Description.new(%w(a ``` b ``` c))
      d.shell_render(out, Condition.new(['b'], SearchTargetFlag.new))
      expect(out.string).to eq "a\n    \e[32m\e[32;4mb\e[m\e[32m\e[m\nc\n"
    end
  end

  describe SearchResult do
    it 'hit?' do
      expect(SearchResult.new(nil).hit?).to be_truthy
    end

    it 'empty?' do
      x = SearchResult.new(nil)
      y = SearchResult.new(nil, [x])
      z = SearchResult.new(nil, [])
      expect(x.empty?).to be_falsey
      expect(y.empty?).to be_falsey
      expect(z.empty?).to be_truthy
    end
  end
end
