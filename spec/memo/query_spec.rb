# frozen_string_literal: true

require 'memo/query'

describe Query do
  it 'initialize with no argument' do
    query = Query.new(['hoge'])
    expect(query.view_setting.stdout).to be Query::ViewSetting.new.stdout
    expect(query.view_setting.index).to be Query::ViewSetting.new.index
    expect(query.view_setting.editor).to be Query::ViewSetting.new.editor
    expect(query.view_setting.brief).to be Query::ViewSetting.new.brief
    expect(query.cond.stf.file_path).to be SearchTargetFlag.new.file_path
    expect(query.cond.stf.title).to be SearchTargetFlag.new.title
    expect(query.cond.stf.description).to be SearchTargetFlag.new.description
    expect(query.cond.patterns[0]).to eq 'hoge'
  end

  it 'initialize with full argument' do
    argv = %w(hoge fuga -s -i 1 -e atom -b -r --no-path --no-title --no-desc)
    query = Query.new(argv)
    expect(query.view_setting.stdout).to be true
    expect(query.view_setting.index).to be 1
    expect(query.view_setting.editor).to eq 'atom'
    expect(query.view_setting.brief).to be true
    expect(query.cond.stf.file_path).to be false
    expect(query.cond.stf.title).to be false
    expect(query.cond.stf.description).to be false
    expect(query.cond.patterns[0]).to eq(/hoge/)
    expect(query.cond.patterns[1]).to eq(/fuga/)
  end
end
