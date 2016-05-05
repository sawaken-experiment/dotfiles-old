# ------------------------------
# 環境構築スクリプト集
#   - ビルドツールとRakeの実行環境が必要. 先にinit.shを実行しておくこと.
#   - Rakefile一般に関するメモ:
#     - ruleのdepsにrule以外を指定しないこと. 差分ビルドが意味を為さなくなる.
# ------------------------------

def home(path)
  ENV['HOME'] + '/' + path
end

def dotfile_status(dotfile_name)
  dotfile_path_home = home(dotfile_name)
  dotfile_path_here = File.expand_path(dotfile_name)
  raise unless dotfile_path_here
  if File.exist?(dotfile_path_home)
    link_dest = `readlink #{dotfile_path_home}`.chomp
    if link_dest == dotfile_path_here
      {:status => :ok, :desc => 'linked from dotfiles'}
    elsif link_dest == ''
      {:status => :warning, :desc => 'entity (the file is not a symlink)'}
    else
      {:status => :warning, :desc => "linked from the other (#{link_dest})"}
    end
  else
    {:status => :error, :desc => 'unlinked (the file does not exist)'}
  end
end

def dotfile_status_colorized(dotfile_name)
  status = dotfile_status(dotfile_name)
  case status[:status]
  when :ok
    green(status[:desc])
  when :warning
    yellow(status[:desc])
  when :error
    red(status[:desc])
  end
end

def shift_path(path)
  ENV['PATH'] = "#{path}:#{ENV['PATH']}"
end

def red(txt)
  "\e[31m" + txt + "\e[m"
end

def green(txt)
  "\e[32m" + txt + "\e[m"
end

def yellow(txt)
  "\e[33m" + txt + "\e[m"
end

# SHELLの環境変数に依存せずにanyenvを実行する
# 注意) anyenvを利用するためには、SHELLが以下の条件を満たす必要が有る
#        * anyenvのパスが通っていること
#        * anyenv initが実行されていること
def ash(command)
  shift_path("#{ENV['HOME']}/.anyenv/bin")
  sh 'eval "$(anyenv init -)"; ' + command
end

DOTFILES = Dir.glob('.*[^~#.]') - ['.git', '.DS_Store']
ANY_ENV = home('.anyenv')
XX_ENV_NAMES = [
  'rbenv',
  'goenv',
  'pyenv',
  'plenv',
  'ndenv',
  'scalaenv',
  'sbtenv',
  'jenv',
].freeze

# anyenv
# ----------

desc 'anyenvをインストールする'
task 'install-anyenv' => ANY_ENV
file ANY_ENV do
  sh 'git clone https://github.com/riywo/anyenv $HOME/.anyenv'
end

desc 'anyenvを削除する'
task 'remove-anyenv' do
  if File.exist?(ANY_ENV)
    print 'remove ~/.anyenv?'
    if STDIN.gets.chomp == 'y'
      sh "rm -fr #{ANY_ENV}"
    else
      fail 'removing anyenv is canceled'
    end
  end
end


# **env
# ----------

XX_ENV_NAMES.each do |xxenv_name|
  xxenv = home('.anyenv/envs/' + xxenv_name)
  desc "anyenvを用いて#{xxenv_name}をインストールする"
  task "install-#{xxenv_name}" => xxenv
  file xxenv => ANY_ENV do
    ash "anyenv install #{xxenv_name}"
  end

  desc "anyenvから#{xxenv_name}を削除する"
  task "remove-#{xxenv_name}" do
    ash "anyenv uninstall #{xxenv_name}" if File.exist?(xxenv)
  end
end

# Ruby
# ----------

desc 'rbenvを用いてRuby環境を構築'
task 'setting-ruby' => 'install-rbenv' do
  ash 'rbenv install 2.3.1'
  ash 'rbenv global 2.3.1'
  ash 'rbenv rehash'
end

# Golang
# ----------

desc 'goenvを用いてGo環境を構築'
task 'setting-go' => 'install-goenv' do
  ash 'goenv install 1.6'
  ash 'goenv global 1.6'
  ash 'goenv rehash'
end

# Python
# ----------

desc 'pyenvを用いてPython環境を構築'
task 'setting-python' => 'install-pyenv' do
  ash 'pyenv install 3.5.1'
  ash 'pyenv install 2.7.11'
  ash 'pyenv global 3.5.1 2.7.11'
  ash 'pyenv rehash'
end

# Node.js
# ----------

desc 'ndenvを用いてNode.js環境を構築'
task 'setting-nodejs' => 'install-ndenv' do
  ash 'ndenv install v4.4.3'
  ash 'ndenv global v4.4.3'
  ash 'ndenv rehash'
end

# Perl
# ----------

desc 'plenvを用いてPerl環境を構築'
task 'setting-perl' => 'install-plenv' do
  ash 'plenv install 5.22.2'
  ash 'plenv global 5.22.2'
  ash 'plenv install-cpanm'
end

# Scala
# ----------

desc 'scalaenvを用いてScala/SBT環境を構築'
task 'setting-scala' => ['install-scalaenv', 'install-sbtenv'] do
  ash 'scalaenv install scala-2.11.8'
  ash 'scalaenv global scala-2.11.8'
  ash 'scalaenv rehash'
  ash 'sbtenv install sbt-0.13.11'
  ash 'sbtenv global sbt-0.13.11'
  ash 'sbtenv rehash'
end

# dotfiles
# ----------

desc 'dotfilesが管理する全dotfileのリンクを張る'
task 'install-dotfiles' => DOTFILES.map{|dotfile| home(dotfile)}
DOTFILES.each do |dotfile|
  dotfile_path_home = home(dotfile)
  dotfile_path_here = File.expand_path(dotfile)
  rule dotfile_path_home do
    symlink(dotfile_path_here, dotfile_path_home)
  end
end

desc 'dotfilesが管理する全dotfileのリンク状態を表示する'
task 'show-dotfiles' do
  width = DOTFILES.map(&:size).max
  DOTFILES.each do |dotfile|
    status = dotfile_status_colorized(dotfile)
    puts "~/%-#{width + 2}s # %s" % [dotfile, status]
  end
end

desc 'dotfilesが管理する全dotfileのリンクを外す'
task 'remove-dotfiles' do
  DOTFILES.each do |dotfile|
    dotfile_path_home = home(dotfile)
    dotfile_path_here = File.expand_path(dotfile)
    if File.exist?(dotfile_path_home)
      link_dest = `readlink #{dotfile_path_home}`.chomp
      rm dotfile_path_home if link_dest == dotfile_path_here
    end
  end
end


namespace :osx do
  desc 'OSX開発環境を構築'
  task 'setting' => [
    'install-dotfiles',
    'setting-ruby',
    'setting-go',
    'setting-scala',
    'setting-sbt',
    'setting-perl',
    'setting-python',
    'setting-nodejs',
    'osx:setting-java',
  ]

  # Homebrew
  # ----------

  desc 'Homebrewをインストールする'
  task 'install-homebrew' do
    next if 'which brew' != ''
    url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'
    sh "ruby -e \"$(curl -fsSL #{url})\""
  end

  desc 'Homebrewをアンインストールする'
  task 'remove-homebrew' do
    script = 'https://gist.githubusercontent.com/mxcl/1173223/raw/afa922fc4ea5851578f4680c6ac11a54a84ff20c/uninstall_homebrew.sh'
    sh "curl -sf #{script} | sh -s"
  end

  # TeX
  # ----------

  #desc 'brew-caskからMacTeXをインストールする'
  task 'install-latex' => 'osx:install-homebrew' do

  end

  # Java
  # ----------

  desc 'jenvとbrewを用いてJava環境を構築'
  task 'setting-java' => ['install-jenv', 'osx:install-homebrew'] do
    sh 'brew tap caskroom/versions'
    sh 'brew cask install java6'
    sh 'brew cask install java7'
    sh 'brew cask install java'
    Dir.glob('/Library/Java/JavaVirtualMachines/jdk*') do |d|
      ash "jenv add #{d}/Contents/Home"
    end
    ash 'jenv global 1.8'
    ash 'jenv rehash'
  end
end
