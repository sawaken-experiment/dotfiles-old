# frozen_string_literal: true

require 'memo/condition'

describe Condition do
  before do
    @cond = Condition.new(%w(hoge fuga), SearchTargetFlag.new)
  end

  it 'stf' do
    stf = SearchTargetFlag.new
    expect(stf.file_path).to equal true
    expect(stf.title).to equal true
    expect(stf.description).to equal true
  end

  it 'attack' do
    dbl = double('Matchable Object')
    allow(dbl).to receive(:match?).with('hoge').and_return(true)
    allow(dbl).to receive(:match?).with('fuga').and_return(false)
    expect(@cond.attack(dbl).patterns).to eq ['fuga']
  end

  it 'mark' do
    res = @cond.mark('ahogeahogefuga', '[', ']')
    expect(res).to eq 'a[hoge]a[hoge][fuga]'
  end
end
