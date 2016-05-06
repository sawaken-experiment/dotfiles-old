require 'setup/util'

namespace :common do

  # anyenv
  # ----------

  ANY_ENV = home('.anyenv')

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

  XX_ENV_NAMES = [
    'rbenv', 'goenv', 'pyenv', 'plenv', 'ndenv', 'scalaenv', 'sbtenv', 'jenv',
  ].freeze

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
  task 'install-ruby' => 'install-rbenv' do
    ash 'rbenv install 2.3.1'
    ash 'rbenv global 2.3.1'
    ash 'rbenv rehash'
  end

  # Golang
  # ----------

  desc 'goenvを用いてGo環境を構築'
  task 'install-go' => 'install-goenv' do
    ash 'goenv install 1.6'
    ash 'goenv global 1.6'
    ash 'goenv rehash'
  end

  # Python
  # ----------

  desc 'pyenvを用いてPython環境を構築'
  task 'install-python' => 'install-pyenv' do
    ash 'pyenv install 3.5.1'
    ash 'pyenv install 2.7.11'
    ash 'pyenv global 3.5.1 2.7.11'
    ash 'pyenv rehash'
  end

  # Node.js
  # ----------

  desc 'ndenvを用いてNode.js環境を構築'
  task 'install-nodejs' => 'install-ndenv' do
    ash 'ndenv install v4.4.3'
    ash 'ndenv global v4.4.3'
    ash 'ndenv rehash'
  end

  # Perl
  # ----------

  desc 'plenvを用いてPerl環境を構築'
  task 'install-perl' => 'install-plenv' do
    ash 'plenv install 5.22.2'
    ash 'plenv global 5.22.2'
    ash 'plenv install-cpanm'
  end

  # Scala
  # ----------

  desc 'scalaenvを用いてScala/SBT環境を構築'
  task 'install-scala' => ['install-scalaenv', 'install-sbtenv'] do
    ash 'scalaenv install scala-2.11.8'
    ash 'scalaenv global scala-2.11.8'
    ash 'scalaenv rehash'
    ash 'sbtenv install sbt-0.13.11'
    ash 'sbtenv global sbt-0.13.11'
    ash 'sbtenv rehash'
  end

  # dotfiles
  # ----------

  DOTFILES = Dir.glob('.*[^~#.]') - ['.git', '.DS_Store', '.travis.yml']

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
end
