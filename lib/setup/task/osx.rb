require 'setup/util'

namespace :osx do
  # Homebrew
  # ----------

  desc 'Homebrewをインストールする'
  task 'install-homebrew' do
    next if which 'brew'
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
    sh "ruby -e \"$(curl -fsSL #{url})\""
  end

  desc 'Homebrewをアンインストールする'
  task 'remove-homebrew' do
    next unless which 'brew'
    script = 'https://gist.githubusercontent.com/mxcl/1173223/raw/afa922fc4ea5851578f4680c6ac11a54a84ff20c/uninstall_homebrew.sh'
    sh "curl -sf #{script} | sh -s"
  end

  desc 'Homebrew-caskをインストールする'
  task 'install-cask' do
    next if which 'cask'
    sh 'brew tap caskroom/cask'
  end

  # TeX
  # ----------

  #desc 'brew-caskからMacTeXをインストールする'
  task 'install-latex' => 'install-homebrew' do

  end

  # Java
  # ----------

  desc 'jenvとbrewを用いてJava環境を構築'
  task 'install-java' => ['common:install-jenv', 'install-cask'] do
    sh 'brew tap caskroom/versions'
    sh 'brew cask install java6'
    sh 'brew cask install java7'
    sh 'brew cask install java'
    Dir.glob('/Library/Java/JavaVirtualMachines/jdk*') do |d|
      ash "echo \"y\ny\ny\n\" | jenv add #{d}/Contents/Home"
    end
    ash 'jenv global 1.8'
    ash 'jenv rehash'
  end
end
