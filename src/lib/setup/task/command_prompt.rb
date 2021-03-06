# frozen_string_literal: true

CommandPromptLayer = Layer.new do |l|
  l.desc 'ドットファイルのリンクを張る'
  l.task 'dotfiles' do
    commands = []
    DOTFILE_NAMES.each do |dotfile|
      home_path = File.expand_path("../#{dotfile}")
      entity_path = File.expand_path("./deployed/#{dotfile}")
      if File.exist?(home_path)
        puts "#{home_path}は既に存在するため, スキップします."
        next
      end
      puts "#{home_path} -> #{entity_path}"
      dir_opt = File.directory?(entity_path) ? ' /D' : ''
      commands << "cmd /c mklink#{dir_opt} \"#{home_path}\" \"#{entity_path}\""
    end
    require 'tempfile'
    Tempfile.open(['link', '.cmd']) do |f|
      commands.each { |command| f.puts command }
      f.flush
      wsh %(powershell -command "Start-Process -Verb runas \\"#{f.path}\\"")
      sleep(2) # リンク処理が終わる前にtempfileが削除されてしまうのを防ぐため
    end
  end

  l.desc 'ドットファイルのリンクを解除する'
  l.task 'remove:dotfiles' do
    home_dir = File.expand_path('..')
    `dir "#{home_dir}"`.each_line do |line_str|
      line = line_str.split(/[\s\t]+/)
      if line[2] == '<SYMLINKD>'
        home_path = File.expand_path('../' + line[3])
        entity_path = File.expand_path(line[3])
        target = line[4][1..-2]
        wsh "rmdir \"#{home_path}\"" if target == entity_path
      elsif line[2] == '<SYMLINK>'
        home_path = File.expand_path('../' + line[3])
        entity_path = File.expand_path(line[3])
        target = line[4][1..-2]
        wsh "del \"#{home_path.tr('/', '\\')}\"" if target == entity_path
      end
    end
  end

  l.desc 'Atomのパッケージをインストールする'
  l.task 'atom-packages' do
    atom_packages.each do |pkg|
      wsh "apm install #{pkg}"
    end
  end

  l.desc 'Chocolateyインストールスクリプトを表示する'
  l.task 'show:chocolatey' do
    file = File.expand_path('./etc/install_chocolatey.ps1')
    raise unless File.exist?(file)
    wsh "notepad.exe \"#{file}\""
  end
end
