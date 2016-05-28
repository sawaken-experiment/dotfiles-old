# frozen_string_literal: true

WindowsLayer = Layer.new do |l|
  l.desc 'ドットファイルのリンクを張る'
  l.task 'dotfiles' do
    require 'tempfile'
    Tempfile.open(['link', '.cmd']) do |f|
      commands = []
      DOTFILES.each do |dotfile|
        home_path = File.expand_path("../#{dotfile}")
        here_path = File.expand_path(dotfile)
        if File.exist?(home_path)
          puts "#{home_path}は既に存在するため, スキップします."
          next
        end
        dir_opt = File.directory?(dotfile) ? ' /D' : ''
        commands << "cmd /c mklink#{dir_opt} \"#{home_path}\" \"#{here_path}\""
      end
      commands.each do |command|
        f.puts command
      end
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
        here_path = File.expand_path(line[3])
        target = line[4][1..-2]
        wsh "rmdir \"#{home_path}\"" if target == here_path
      elsif line[2] == '<SYMLINK>'
        home_path = File.expand_path('../' + line[3])
        here_path = File.expand_path(line[3])
        target = line[4][1..-2]
        wsh "del \"#{home_path.tr('/', '\\')}\"" if target == here_path
      end
    end
  end

  l.desc 'Atomのパッケージをインストールする'
  l.task 'atom-packages' do
    atom_packages.each do |pkg|
      wsh "apm install #{pkg}"
    end
  end
end
