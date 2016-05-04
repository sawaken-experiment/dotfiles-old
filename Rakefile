# ------------------------------
# 環境構築スクリプト集
#   - Rubyの実行環境が必要
#   - Tips
#     - ruleのdepsにrule以外を指定しないこと
# ------------------------------

def com_exist?(command)
  `which #{command}` != ''
end

def home(path)
  ENV['HOME'] + '/' + path
end

def dotfile_status(dotfile)
  dotfile_home = home(dotfile)
  dotfile_here = File.expand_path(dotfile)
  if File.exist?(dotfile_home)
    link_dest = `readlink #{dotfile_home}`.chomp
    if link_dest == dotfile_here
      'linked from dotfiles'
    elsif link_dest == ''
      'entity (the file is not a symlink)'
    else
      "linked from the other (#{link_dest})"
    end
  else
    'unlinked (the file does not exist)'
  end
end

DOTFILES = Dir.glob('.*[^~#.]') - ['.git', '.DS_Store']
ANY_ENV = home('.anyenv')
XX_ENV_NAMES = [
  'rbenv',
  'goenv',
  'pyenv',
  'ndenv',
  'scalaenv',
  'sbtenv',
].freeze

# OSX
# ----------

desc 'OSX開発環境を構築'
task 'setting-osx' => [
  'install-dotfiles',
  'setting-ruby',
  'setting-go'
]

# Build-tool
# ----------

desc 'development-toolsをインストール'
task 'install-devtools' do
  next if `which cc`.chomp != ''
  if `uname`.chomp == 'Darwin'
    sh 'xcode-select --install'
  elsif `which apt-get`.chomp != ''
    sh 'sudo apt-get install -y build-essentials'
  elsif `which yum`.chomp != ''
    sh 'sudo yum install -y "Development Tools"'
    sh 'yum install -y kernel-devel kernel-headers'
  else
    abort 'Unsupported system.'
  end
end


# anyenv
# ----------

desc 'anyenvをインストールする'
task 'install-anyenv' => ['install-devtools', ANY_ENV]
file ANY_ENV do
  sh 'git clone https://github.com/riywo/anyenv $HOME/.anyenv'
  sh 'eval "$(anyenv init -)"'
end

desc 'anyenvを削除する'
task 'remove-anyenv' do
  sh "rm -fr #{ANY_ENV}" if File.exist?(ANY_ENV)
end


# **env
# ----------

XX_ENV_NAMES.each do |xxenv_name|
  xxenv = home('.anyenv/envs/' + xxenv_name)
  desc "anyenvを用いて#{xxenv_name}をインストールする"
  task "install-#{xxenv_name}" => ['install-devtools', xxenv]
  file xxenv => ANY_ENV do
    sh "anyenv install #{xxenv_name}"
  end

  desc "anyenvから#{xxenv_name}を削除する"
  task "remove-#{xxenv_name}" do
    sh "rm -fr #{xxenv}" if File.exist?(xxenv)
  end
end

# Ruby
# ----------

desc 'rbenvを用いてRuby環境を構築'
task 'setting-ruby' => 'install-rbenv' do
  sh 'rbenv install 2.3.1'
  sh 'rbenv global 2.3.1'
  sh 'rbenv rehash'
  sh 'gem install bundle'
  sh 'rbenv rehash'
end

# Golang
# ----------

desc 'goenvを用いてGo環境を構築'
task 'setting-go' => 'install-goenv' do
  sh 'goenv install 1.6'
  sh 'goenv global 1.6'
  sh 'goenv rehash'
end

# Python
# ----------

desc 'pyenvを用いてPython環境を構築'
task 'setting-python' => 'install-pyenv' do
  sh 'pyenv install 3.5.1'
  sh 'pyenv install 2.7.11'
  sh 'pyenv global 3.5.1 2.7.11'
  sh 'pyenv rehash'
end

# Node.js
# ----------

desc 'ndenvを用いてNode.js環境を構築'
task 'setting-nodejs' => 'install-ndenv' do

end

# Perl
# ----------

desc 'plenvを用いてPerl環境を構築'
task 'setting-perl' => 'install-plenv' do
  sh 'plenv install 5.22.2'
  sh 'plenv global 5.22.2'
  sh 'plenv install-cpanm'
end

# Scala
# ----------

desc 'scalaenvを用いてScala/SBT環境を構築'
task 'setting-scala' => ['install-scalaenv', 'install-sbtenv'] do
  sh 'scalaenv install scala-2.11.8'
  sh 'scalaenv global scala-2.11.8'
  sh 'scalaenv rehash'
  sh 'sbtenv install sbt-0.13.11'
  sh 'sbtenv global sbt-0.13.11'
  sh 'sbtenv rehash'
end

# Homebrew
# ----------

desc 'Homebrewをインストールする'
task 'install-homebrew' => 'install-devtools' do
  next if 'which brew' != ''
  url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
  sh "ruby -e \"$(curl -fsSL #{url})\""
end

# LaTex
# ----------

desc 'brew-caskからMacTeXをインストールする'
task 'install-mactex' => 'install-brew' do
  sh 'brew cask install mactex'
end

# dotfiles
# ----------

desc 'dotfilesが管理する全dotfileのリンクを張る'
task 'install-dotfiles' => DOTFILES.map{|dotfile| home(dotfile)}
DOTFILES.each do |dotfile|
  dotfile_home = home(dotfile)
  dotfile_here = File.expand_path(dotfile)
  rule dotfile_home do
    symlink(dotfile_here, dotfile_home)
  end
end

desc 'dotfilesが管理する全dotfileのリンク状態を表示する'
task 'show-dotfiles' do
  width = DOTFILES.map(&:size).max
  DOTFILES.each do |dotfile|
    status = dotfile_status(dotfile)
    puts "~/%-#{width + 2}s %s" % [dotfile, status]
  end
end

desc 'dotfilesが管理する全dotfileのリンクを外す'
task 'remove-dotfiles' do
  DOTFILES.each do |dotfile|
    dotfile_home = home(dotfile)
    dotfile_here = File.expand_path(dotfile)
    if File.exist?(dotfile_home)
      link_dest = `readlink #{dotfile_home}`.chomp
      rm dotfile_home if link_dest == dotfile_here
    end
  end
end
