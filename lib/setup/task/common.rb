require 'setup/util'

namespace :common do

  # anyenv
  # ----------

  ANY_ENV = home('.anyenv')

  desc 'anyenvをインストールする'
  task 'install:anyenv' do
    next if File.exist?(ANY_ENV)
    sh 'git clone https://github.com/riywo/anyenv $HOME/.anyenv'
    fail 'assert' unless File.exist?(ANY_ENV)
  end

  desc 'anyenvを削除する'
  task 'remove:anyenv' do
    next unless File.exist?(ANY_ENV)
    sh "rm -fr #{ANY_ENV}"
    fail 'assert' if File.exist?(ANY_ENV)
  end

  # **env
  # ----------

  XX_ENV_NAMES = [
    'rbenv', 'goenv', 'pyenv', 'plenv', 'ndenv', 'scalaenv', 'sbtenv', 'jenv',
  ].freeze

  XX_ENV_NAMES.each do |xxenv_name|
    xxenv = home('.anyenv/envs/' + xxenv_name)

    desc "anyenvを用いて#{xxenv_name}をインストールする"
    task "install:#{xxenv_name}" => 'install:anyenv' do
      next if File.exist?(xxenv)
      ash "anyenv install #{xxenv_name}"
      fail 'assert' if asho("which #{xxenv_name}") == ''
    end

    desc "anyenvから#{xxenv_name}を削除する"
    task "remove:#{xxenv_name}" do
      next unless File.exist?(xxenv)
      ash "anyenv uninstall #{xxenv_name}" if File.exist?(xxenv)
      fail 'assert' unless asho("which #{xxenv_name}") == ''
    end
  end

  # Ruby
  # ----------

  desc 'rbenvを用いてRuby環境を構築'
  task 'install:ruby' => 'install:rbenv' do
    v = '2.3.1'
    ash "rbenv install #{v}" unless asho('rbenv versions').index(v)
    ash "rbenv global #{v}"
    ash 'rbenv rehash'
    fail 'assert' unless asho('ruby -v').index(v)
  end

  # Golang
  # ----------

  desc 'goenvを用いてGoをインストールする'
  task 'install:go' => 'install:goenv' do
    v = '1.6'
    ash "goenv install #{v}" unless asho('goenv versions').index(v)
    ash "goenv global #{v}"
    ash 'goenv rehash'
    fail 'assert' unless asho('go version').index(v)
  end

  # Python
  # ----------

  desc 'pyenvを用いてPython2/Python3をインストールする'
  task 'install:python' => 'install:pyenv' do
    v2 = '2.7.11'
    ash "pyenv install #{v2}" unless asho('pyenv versions').index(v2)
    ash "pyenv global #{v2}"
    ash 'pyenv rehash'
    fail 'assert' unless asho('python2 -V 2>&1').index(v2)
    v3 = '3.5.1'
    ash "pyenv install #{v3}" unless asho('pyenv versions').index(v3)
    ash "pyenv global #{v3}"
    ash 'pyenv rehash'
    fail 'assert' unless asho('python -V 2>&1').index(v3)
  end

  # Node.js
  # ----------

  desc 'ndenvを用いてNode.jsをインストールする'
  task 'install:nodejs' => 'install:ndenv' do
    v = '4.4.3'
    ash "ndenv install v#{v}" unless asho('ndenv versions').index(v)
    ash "ndenv global v#{v}"
    ash 'ndenv rehash'
    fail 'assert' unless asho('node -v').index(v)
  end

  # Perl
  # ----------

  desc 'plenvを用いてPerl5とCPANをインストールする'
  task 'install:perl' => 'install:plenv' do
    v = '5.22.2'
    ash "plenv install #{v}" unless asho('plenv versions').index(v)
    ash "plenv global #{v}"
    ash 'plenv install-cpanm'
    fail 'assert' unless asho('perl -v').index(v)
  end

  # Scala
  # ----------

  desc 'scalaenvを用いてScalaをインストールする'
  task 'install:scala' => 'install:scalaenv' do
    v = '2.11.8'
    unless asho('scalaenv versions').index(v)
      ash "scalaenv install scala-#{v}"
    end
    ash "scalaenv global scala-#{v}"
    ash 'scalaenv rehash'
    fail 'assert' unless asho('scala -version 2>&1').index(v)
  end

  desc 'sbtenvを用いてSBTをインストールする'
  task 'install:sbt' => 'install:sbtenv' do
    v = '0.13.11'
    unless asho('sbtenv versions').index(v)
      ash "sbtenv install sbt-#{v}"
    end
    ash "sbtenv global sbt-#{v}"
    ash 'sbtenv rehash'
    fail 'assert' unless asho('sbt sbt-version').index(v)
  end

  # dotfiles
  # ----------

  DOTFILES = Dir.glob('.*[^~#.]') - ['.git', '.DS_Store', '.travis.yml']

  desc 'dotfilesが管理する全dotfileのリンクを張る'
  task 'install:dotfiles' do
    DOTFILES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path(dotfile)
      unless File.exist?(dotfile_path_home)
        symlink(dotfile_path_here, dotfile_path_home)
      end
      fail 'assert' unless File.exist?(dotfile_path_home)
    end
  end

  desc 'dotfilesが管理する全dotfileのリンク状態を表示する'
  task 'show:dotfiles' do
    width = DOTFILES.map(&:size).max
    DOTFILES.each do |dotfile|
      status = dotfile_status_colorized(dotfile)
      puts "~/%-#{width + 2}s # %s" % [dotfile, status]
    end
  end

  desc 'dotfilesが管理する全dotfileのリンクを外す'
  task 'remove:dotfiles' do
    DOTFILES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path(dotfile)
      if File.exist?(dotfile_path_home)
        link_dest = `readlink #{dotfile_path_home}`.chomp
        rm dotfile_path_home if link_dest == dotfile_path_here
      end
      if `readlink #{dotfile_path_home}`.chomp == dotfile_path_here
        fail 'assert'
      end
    end
  end
end
