require 'setup/util'

namespace :osx do
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

  # TeX
  # ----------

  #desc 'brew-caskからMacTeXをインストールする'
  task 'install:latex' => 'install:homebrew' do

  end

  # Java
  # ----------

  desc 'jenvとbrewを用いてJavaをインストールする'
  task 'install:java' => ['common:install:jenv', 'install:homebrew'] do
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
