require 'setup/util'

namespace :osx do

  desc '(Homebrew-caskを用いない)OSX項目を全てインストールする'
  task 'install' do
    namespace('osx:install'){}.tasks.each do |t|
      t.invoke
    end
  end

  desc '(Homebrew-caskを用いない)OSX項目を全てアンインストールする'
  task 'remove' do
    namespace('osx:remove'){}.tasks.each do |t|
      t.invoke
    end
  end

  # Homebrew
  # ----------

  desc 'Homebrewをインストールする'
  task 'install:homebrew' do
    next if which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
    sh "ruby -e \"$(curl -fsSL #{url})\""
    fail 'assert' unless which 'brew'
  end

  desc 'Homebrewをアンインストールする'
  task 'remove:homebrew' do
    next unless which 'brew'
    script = 'https://gist.githubusercontent.com/mxcl/1173223/raw/afa922fc4ea5851578f4680c6ac11a54a84ff20c/uninstall_homebrew.sh'
    sh "curl -sf #{script} | sh -s"
    fail 'assert' if which 'brew'
  end

  # CUI-Tools
  # ----------

  desc '各種コマンドラインツールをインストールする'
  task 'install:cui-tools' => 'install:homebrew' do
    # tmux
    sh 'brew install tmux reattach-to-user-namespace'
  end

  # Terminal Theme
  # ----------

  desc 'Terminal.appのテーマSolarized-Darkをインストールする'
  task 'install:terminal-theme' do
    url = 'https://github.com/tomislav/osx-terminal.app-colors-solarized'
    begin
      sh "git clone #{url} ./solarized"
      sh "open -a Terminal.app \"./solarized/Solarized Dark.terminal\""
    ensure
      sh 'rm -fr ./solarized'
    end
  end

  # Keynote Theme
  # ----------

  desc 'KeynoteのテーマAzusa-Colorsをインストールする'
  task 'install:keynote-theme' => 'common:install:dotfiles' do
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
end

# Haskell
# ----------

desc 'homebrewとhaskell-stackを用いてHaskell開発環境をインストール'
task 'install:haskell-stack' => 'install:homebrew' do
  sh 'brew install haskell-stack'
  sh 'stack setup'
end

# Cask
#   - brew-cask-installはパスワードを尋ねられるので, 別namespaceに分けている.
# ----------
namespace 'osx-cask' do

  desc 'Homebrew-caskを用いるOSX項目を全てインストールする'
  task 'install' do
    namespace('osx-cask:install'){}.tasks.each do |t|
      t.invoke
    end
  end

  desc 'Homebrew-caskを用いるOSX項目を全てアンインストールする'
  task 'remove' do
    namespace('osx-cask:remove'){}.tasks.each do |t|
      t.invoke
    end
  end

  # GUI-Tools
  # ----------

  desc 'homebrew-caskを用いて各種APPをインストールする'
  task 'install:gui-tools' => 'osx:install:homebrew' do
    sh 'brew tap caskroom/cask'
    # Atom
    sh 'brew cask install atom'
    sh 'apm install --packages-file .atom/pkg-list'
    # IntelliJ
    sh 'brew cask install intellij-ide'
    # ブラウザ
    sh 'brew cask install firefox'
    sh 'brew cask install google-chrome'
    # TeX
    # キーボード設定util(リピート速度, リピート認識開始速度)
    sh 'brew cask install karabiner'
    # ターミナル
    sh 'brew cask install iterm2'
    # オンラインストレージ
    sh 'brew cask install google-drive'
    sh 'brew cask install dropbox'
  end

  # Java
  # ----------

  desc 'jenvとbrewを用いてJava6,7,8をインストールする'
  task 'install:java' => ['common:install:jenv', 'osx:install:homebrew'] do
    sh 'brew tap caskroom/cask'
    sh 'brew tap caskroom/versions'
    sh 'brew cask install java6'
    sh 'brew cask install java7'
    sh 'brew cask install java'
    Dir.glob('/Library/Java/JavaVirtualMachines/jdk*') do |d|
      ash "echo \"y\ny\ny\n\" | jenv add #{d}/Contents/Home"
    end
    ash 'jenv global 1.8'
    ash 'jenv rehash'
    fail 'assert' unless asho("java -version 2>&1").index('1.8')
  end
end
