require 'setup/util'

layer :osx => :common do

  ldesc '全てをアンインストール'
  ltask 'remove:all' => [
    'remove:homebrew', 'remove:anyenv', 'remove:dotfiles'
  ]

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  ldesc 'jenvとbrewを用いてJava6,7,8をインストールする'
  ltask 'java' => ['jenv', 'homebrew'] do
    shq 'brew tap caskroom/cask'
    shq 'brew tap caskroom/versions'
    shq 'brew cask install java6'
    shq 'brew cask install java7'
    shq 'brew cask install java'
    Dir.glob('/Library/Java/JavaVirtualMachines/jdk*') do |d|
      ash "echo \"y\ny\ny\n\" | jenv add #{d}/Contents/Home"
    end
    ash 'jenv global 1.8'
    ash 'jenv rehash'
    fail 'assert' unless asho("java -version 2>&1").index('1.8')
  end

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  ldesc 'haskell-stackを用いてHaskell開発環境をインストール'
  ltask 'haskell' => 'homebrew' do
    shq 'brew install haskell-stack'
    shq 'stack setup'
  end

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  ldesc 'アプリケーションを全てインストールする'
  ltask 'applications' => [
    'cui-tools', 'gui-tools', 'atom', 'atom-packages',
    'keynote-theme', 'terminal-theme'
  ]

  ldesc '各種コマンドラインツールをインストールする'
  ltask 'cui-tools' => 'homebrew' do
    # tmux
    shq 'brew install tmux reattach-to-user-namespace'
    # Emacs
    shq 'brew install emacs --with-cocoa --with-gnutls'
  end

  ldesc 'homebrew-caskを用いて各種APPをインストールする'
  ltask 'gui-tools' => 'homebrew' do
    shq 'brew tap caskroom/cask'
    # IntelliJ
    shq 'brew cask install intellij-idea'
    # ブラウザ
    shq 'brew cask install firefox'
    shq 'brew cask install google-chrome'
    # TeX
    # キーボード設定util(リピート速度, リピート認識開始速度)
    shq 'brew cask install karabiner'
    # ターミナル
    shq 'brew cask install iterm2'
    # オンラインストレージ
    shq 'brew cask install google-drive'
    shq 'brew cask install dropbox'
  end

  ldesc 'Atomをインストールする'
  ltask 'atom' => 'homebrew' do
    shq 'brew cask install atom'
  end

  ldesc 'KeynoteのテーマAzusa-Colorsをインストールする'
  ltask 'keynote-theme' => 'dotfiles' do
    begin
      sh "git clone https://github.com/sanographix/azusa-colors/ ./azusa-colors"
      cd './azusa-colors' do
        sh 'unzip theme-azusa-colors.kth.zip'
        sh 'mv -f theme-azusa-colors.kth $HOME/.dotfiles-target/'
      end
      sh 'open $HOME/.dotfiles-target/theme-azusa-colors.kth'
    ensure
      sh "rm -rf ./azusa-colors"
    end
  end

  ldesc 'Terminal.appのテーマSolarized-Darkをインストールする'
  ltask 'terminal-theme' do
    url = 'https://github.com/tomislav/osx-terminal.app-colors-solarized'
    begin
      sh "git clone #{url} ./solarized"
      sh "open -a Terminal.app \"./solarized/Solarized Dark.terminal\""
    ensure
      sh 'rm -fr ./solarized'
    end
  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  ldesc 'Homebrewをインストールする'
  ltask 'homebrew' do
    next if which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
    sh "echo \"\n\" | ruby -e \"$(curl -fsSL #{url})\""
    fail 'assert' unless which 'brew'
  end

  ldesc 'Homebrewをアンインストールする'
  ltask 'remove:homebrew' do
    next unless which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/uninstall'
    sh "echo y | ruby -e \"$(curl -fsSL #{url})\""
    fail 'assert' if which 'brew'
  end

  ldesc 'ビルドに必要なライブラリを一通りインストールする'
  ltask 'build-lib' => ['homebrew'] do
    shq 'brew install openssl readline'
  end
end
