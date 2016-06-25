# frozen_string_literal: true

OSXLayer = Layer.new do |l|
  l.task 'remove:all' => [
    'remove:homebrew', 'remove:anyenv', 'remove:dotfiles'
  ]

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  l.desc 'Oracle Java7, 8をインストールし, jenvの監視下に置く'
  l.task 'java' => %w(jenv homebrew) do
    shq 'brew tap caskroom/cask'
    shq 'brew tap caskroom/versions'
    shq 'brew cask install java7'
    shq 'brew cask install java'
    Dir.glob('/Library/Java/JavaVirtualMachines/jdk*') do |d|
      ash "echo \"y\ny\ny\n\" | jenv add #{d}/Contents/Home"
    end
    ash 'jenv global 1.8'
    ash 'jenv rehash'
    raise 'assert' unless asho('java -version 2>&1').index('1.8')
  end

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  l.task 'haskell' => 'homebrew' do
    shq 'brew install haskell-stack'
    shq 'stack setup'
  end

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  l.task 'applications' => [
    'cui-tools', 'gui-tools', 'atom', 'atom-packages',
    'keynote-theme', 'terminal-theme'
  ]

  l.desc '各種コマンドラインツールをインストールする'
  l.task 'cui-tools' => 'homebrew' do
    # tmux
    shq 'brew install tmux reattach-to-user-namespace'
    # Emacs
    shq 'brew install emacs --with-cocoa --with-gnutls'
  end

  l.desc 'homebrew-caskを用いて各種APPをインストールする'
  l.task 'gui-tools' => 'homebrew' do
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

  l.desc 'Atomをインストールする'
  l.task 'atom' => %w(homebrew dotfiles) do
    shq 'brew cask install atom'
    task('atom-packages').invoke
  end

  l.desc 'KeynoteのテーマAzusa-Colorsをインストールする'
  l.task 'keynote-theme' => 'dotfiles' do
    begin
      sh 'git clone https://github.com/sanographix/azusa-colors/ ./azusa-colors'
      cd './azusa-colors' do
        sh 'unzip theme-azusa-colors.kth.zip'
        sh "mv -f theme-azusa-colors.kth #{TARGET_DIR_PATH}"
      end
      sh "open #{TARGET_DIR_PATH}/theme-azusa-colors.kth"
    ensure
      sh 'rm -rf ./azusa-colors'
    end
  end

  l.desc 'Terminal.appのテーマSolarized-Darkをインストールする'
  l.task 'terminal-theme' do
    url = 'https://github.com/tomislav/osx-terminal.app-colors-solarized'
    begin
      sh "git clone #{url} ./solarized"
      sh 'open -a Terminal.app "./solarized/Solarized Dark.terminal"'
    ensure
      sh 'rm -fr ./solarized'
    end
  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  l.desc 'Homebrewをインストールする'
  l.task 'homebrew' do
    next if which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
    sh "echo \"\n\" | ruby -e \"$(curl -fsSL #{url})\""
    raise 'assert' unless which 'brew'
  end

  l.desc 'Homebrewをアンインストールする'
  l.task 'remove:homebrew' do
    next unless which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/uninstall'
    sh "echo y | ruby -e \"$(curl -fsSL #{url})\""
    raise 'assert' if which 'brew'
  end

  l.task 'build-lib' => ['homebrew'] do
    shq 'brew install openssl readline'
  end
end
