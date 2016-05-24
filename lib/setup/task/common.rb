require 'setup/util'

layer :common do
  ldesc '全てインストールする'
  ltask 'all' => %w(languages applications dotfiles)

  ldesc 'プログラミング言語処理系を全てインストールする'
  ltask 'languages' => %w(
    ruby python nodejs go perl scala sbt java haskell
  )

  ldesc '全てアンインストールする'
  ltask 'remove:all' => :fail

  # ----------------------------------------------------------------------
  # Ruby
  # ----------------------------------------------------------------------

  ldesc 'rbenvを用いてRubyをインストール'
  ltask 'ruby' => ['rbenv', 'build-lib'] do
    # rbenvのプラグインをインストール
    path = ENV['HOME'] + '/.anyenv/envs/rbenv/plugins/rbenv-binstubs'
    unless File.exist?(path)
      sh "git clone https://github.com/ianheggie/rbenv-binstubs.git #{path}"
    end
    v = '2.3.1'
    ash "rbenv install #{v}" unless asho('rbenv versions').index(v)
    ash "rbenv global #{v}"
    # GemのGlobalインストール
    ash 'rbenv exec gem install bundle pry travis --no-document'
    ash 'rbenv rehash'
    ash 'bundle -v; pry -v'
    ash 'echo y | travis -v'
    raise 'assert' unless asho('ruby -v').index(v)
  end

  # ----------------------------------------------------------------------
  # Golang
  # ----------------------------------------------------------------------

  ldesc 'goenvを用いてGoをインストールする'
  ltask 'go' => ['goenv', 'build-lib'] do
    v = '1.6'
    ash "goenv install #{v} 2>/dev/null" unless asho('goenv versions').index(v)
    ash "goenv global #{v}"
    ash 'goenv rehash'
    raise 'assert' unless asho('go version').index(v)
  end

  # ----------------------------------------------------------------------
  # Python
  # ----------------------------------------------------------------------

  ldesc 'pyenvを用いてPython2/Python3をインストールする'
  ltask 'python' => ['pyenv', 'build-lib'] do
    v2 = '2.7.11'
    v3 = '3.5.1'
    ash "pyenv install #{v2}" unless asho('pyenv versions').index(v2)
    ash "pyenv install #{v3}" unless asho('pyenv versions').index(v3)
    ash "pyenv global #{v3} #{v2}"
    ash 'pyenv rehash'
    raise 'assert' unless asho('python2 -V 2>&1').index(v2)
    raise 'assert' unless asho('python -V 2>&1').index(v3)
  end

  # ----------------------------------------------------------------------
  # Node.js
  # ----------------------------------------------------------------------

  ldesc 'ndenvを用いてNode.jsをインストールする'
  ltask 'nodejs' => ['ndenv', 'build-lib'] do
    v = '4.4.3'
    ash "ndenv install v#{v}" unless asho('ndenv versions').index(v)
    ash "ndenv global v#{v}"
    ash 'ndenv rehash'
    raise 'assert' unless asho('node -v').index(v)
  end

  # ----------------------------------------------------------------------
  # Perl
  # ----------------------------------------------------------------------

  ldesc 'plenvを用いてPerl5とCPANをインストールする'
  ltask 'perl' => ['plenv', 'build-lib'] do
    v = '5.22.2'
    unless asho('plenv versions').index(v)
      ash "plenv install #{v} 2>/dev/null 1>/dev/null"
    end
    ash "plenv global #{v}"
    ash 'plenv install-cpanm 2>/dev/null 1>/dev/null'
    raise 'assert' unless asho('perl -v').index(v)
  end

  # ----------------------------------------------------------------------
  # Scala
  # ----------------------------------------------------------------------

  ldesc 'scalaenvを用いてScalaをインストールする'
  ltask 'scala' => ['scalaenv', 'build-lib'] do
    v = '2.11.8'
    ash "scalaenv install scala-#{v}" unless asho('scalaenv versions').index(v)
    ash "scalaenv global scala-#{v}"
    ash 'scalaenv rehash'
    raise 'assert' unless asho('scala -version 2>&1').index(v)
  end

  ldesc 'sbtenvを用いてSBTをインストールする'
  ltask 'sbt' => ['sbtenv', 'build-lib'] do
    v = '0.13.11'
    ash "sbtenv install sbt-#{v}" unless asho('sbtenv versions').index(v)
    ash "sbtenv global sbt-#{v}"
    ash 'sbtenv rehash'
    raise 'assert' unless asho('sbt sbt-version').index(v)
  end

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  ltask 'java' => :fail

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  ldesc 'haskell-stackを用いてHaskell開発環境をインストール'
  ltask 'haskell' => :fail

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  ldesc 'アプリケーションを全てインストールする'
  ltask 'applications' => :fail

  ldesc 'Atomのパッケージをインストールする'
  ltask 'atom-packages' do
    atom_packages.each do |pkg|
      sh "apm install #{pkg}"
    end
  end

  # ----------------------------------------------------------------------
  # ドットファイル
  # ----------------------------------------------------------------------

  ldesc 'dotfilesが管理する全dotfileのリンクを張る'
  ltask 'dotfiles' do
    DOTFILES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path(dotfile)
      unless File.exist?(dotfile_path_home)
        symlink(dotfile_path_here, dotfile_path_home)
      end
      raise 'assert' unless File.exist?(dotfile_path_home)
    end
  end

  ldesc 'dotfilesが管理する全dotfileのリンク状態を表示する'
  ltask 'show:dotfiles' do
    width = DOTFILES.map(&:size).max
    DOTFILES.each do |dotfile|
      status = dotfile_status_colorized(dotfile)
      puts format("~/%-#{width + 2}s # %s", dotfile, status)
    end
  end

  ldesc 'dotfilesが管理する全dotfileのリンクを外す'
  ltask 'remove:dotfiles' do
    DOTFILES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path(dotfile)
      if File.exist?(dotfile_path_home)
        link_dest = `readlink #{dotfile_path_home}`.chomp
        rm dotfile_path_home if link_dest == dotfile_path_here
      end
      if `readlink #{dotfile_path_home}`.chomp == dotfile_path_here
        raise 'assert'
      end
    end
  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  ANY_ENV = home('.anyenv')

  ldesc 'anyenvをインストールする'
  ltask 'anyenv' do
    next if File.exist?(ANY_ENV)
    sh 'git clone https://github.com/riywo/anyenv $HOME/.anyenv'
    raise 'assert' unless File.exist?(ANY_ENV)
  end

  ldesc 'anyenvを削除する'
  ltask 'remove:anyenv' do
    next unless File.exist?(ANY_ENV)
    sh "rm -fr #{ANY_ENV}"
    raise 'assert' if File.exist?(ANY_ENV)
  end

  XX_ENV_NAMES = %w(
    rbenv goenv pyenv plenv ndenv scalaenv sbtenv jenv
  ).freeze

  XX_ENV_NAMES.each do |xxenv_name|
    xxenv = home('.anyenv/envs/' + xxenv_name)

    ldesc "anyenvを用いて#{xxenv_name}をインストールする"
    ltask xxenv_name => 'anyenv' do
      next if File.exist?(xxenv)
      ash "anyenv install #{xxenv_name}"
      raise 'assert' if asho("which #{xxenv_name}") == ''
    end

    ldesc "anyenvから#{xxenv_name}を削除する"
    ltask "remove:#{xxenv_name}" do
      next unless File.exist?(xxenv)
      ash "echo y | anyenv uninstall #{xxenv_name}" if File.exist?(xxenv)
      raise 'assert' unless asho("which #{xxenv_name}") == ''
    end
  end

  ldesc 'ビルドに必要なライブラリを一通りインストールする'
  ltask 'build-lib' => :fail
end
