# -*- coding: utf-8 -*-
layer :windows do
  ldesc 'ドットファイルのリンクを張る'
  ltask 'dotfiles' do
    DOTFILES.each do |f|
      home_path = File.expand_path("../#{f}")
      here_path = File.expand_path(f)
      if File.exist?(home_path)
        puts "#{home_path} already exists: skipped"
        next
      end
      dir_opt = File.directory?(f) ? ' /D' : ''
      wsh "cmd /c mklink #{dir_opt} \"#{home_path}\" \"#{here_path}\""
    end
  end

  ldesc 'ドットファイルのリンクを解除する'
  ltask 'remove:dotfiles' do
    home_dir = File.expand_path('..')
    `dir "#{home_dir}"`.each_line do |line_str|
      line = line_str.split(/[\s\t]+/)
      if line[2] == "<SYMLINKD>"
        home_path = File.expand_path('../' + line[3])
        here_path = File.expand_path(line[3])
        target = line[4][1..-2]
        if target == here_path
          wsh "rmdir \"#{home_path}\""
        end
      elsif line[2] == "<SYMLINK>"
        home_path = File.expand_path('../' + line[3])
        here_path = File.expand_path(line[3])
        target = line[4][1..-2]
        if target == here_path
          wsh "del \"#{home_path.gsub('/', "\\")}\""
        end
      end
    end
  end

  ldesc 'Atomのパッケージをインストールする'
  ltask 'atom-packages' do
    atom_packages().each do |pkg|
      wsh "apm install #{pkg}"
    end
  end
end
