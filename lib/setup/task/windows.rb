layer :windows do
  ldesc 'ドットファイルのリンクを張る'
  ltask 'dotfiles' do
    DOTFILES.each do |f|
      if File.directory?(f)
        sh "mklink /D #{f} dotfiles\\#{f}"
      else
        sh "mklink #{f} dotfiles\\#{f}"
      end
    end
  end
end
