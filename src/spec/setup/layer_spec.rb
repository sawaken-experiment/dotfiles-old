# frozen_string_literal: true

require 'setup/layer'

describe Layer do
  X = Layer.new do |l|
    l.desc 'hoge nan dayo'
    l.task 'hoge' => 'fuga' do
      puts 'hoge in x'
    end

    l.desc 'described in x'
    l.task 'pan' do
      puts 'pan in x'
    end
  end

  Y = Layer.new do |l|
    l.desc 'fuga nan dayo'
    l.task 'fuga' do
      puts 'fuga in y'
    end

    l.task 'pan' do
      puts 'pan in y'
    end
  end

  it 'layer X has one perfect task pan' do
    expect(X.perfect_tasks.map(&:name)).to eq ['pan']
    expect(X.task_h['pan'].desc).to eq('described in x')
  end

  it 'layer X has one imperfect task hoge' do
    expect(X.imperfect_tasks.map(&:name)).to eq ['hoge']
    expect(X.task_h['hoge'].desc).to eq('hoge nan dayo')
  end

  it 'layer Y has two perfect tasks fuga, pan' do
    expect(Y.perfect_tasks.map(&:name)).to eq %w(fuga pan)
    expect(Y.task_h['fuga'].desc).to eq('fuga nan dayo')
    expect(Y.task_h['pan'].desc).to eq(nil)
  end

  it 'layer Y has no imperfect tasks' do
    expect(Y.imperfect_tasks.map(&:name)).to eq []
  end

  it 'layer X on Y has three perfect tasks' do
    expect(X.onto(Y).perfect_tasks.map(&:name)).to eq %w(fuga pan hoge)
    expect(X.onto(Y).task_h['fuga'].desc).to eq('fuga nan dayo')
    expect(X.onto(Y).task_h['hoge'].desc).to eq('hoge nan dayo')
    expect(X.onto(Y).task_h['pan'].desc).to eq('described in x')
  end

  it 'layer X on Y has no imperfect tasks' do
    expect(X.onto(Y).imperfect_tasks.map(&:name)).to eq []
  end

  it 'layer Y on X has three perfect tasks' do
    expect(Y.onto(X).perfect_tasks.map(&:name)).to eq %w(hoge pan fuga)
    expect(Y.onto(X).task_h['fuga'].desc).to eq('fuga nan dayo')
    expect(Y.onto(X).task_h['hoge'].desc).to eq('hoge nan dayo')
    expect(Y.onto(X).task_h['pan'].desc).to eq('described in x')
  end

  it 'layer Y on X has no imperfect tasks' do
    expect(Y.onto(X).imperfect_tasks.map(&:name)).to eq []
  end
end
