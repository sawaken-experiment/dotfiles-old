# frozen_string_literal: true

CommonLayer = Layer.new do |l|
  l.desc '全てインストールする'
  l.task 'all' => %w(languages applications environment dotfiles)

  l.desc 'プログラミング言語処理系を全てインストールする'
  l.task 'languages' => %w(
    ruby python nodejs go perl scala sbt java haskell ocaml
  )

  l.desc '全てアンインストールする'
  l.task 'remove:all' => :fail

  # ----------------------------------------------------------------------
  # Ruby
  # ----------------------------------------------------------------------

  l.desc 'rbenvを用いてRubyをインストール'
  l.task 'ruby' => ['rbenv', 'build-lib'] do
    # rbenvのプラグインをインストール
    path = ENV['HOME'] + '/.anyenv/envs/rbenv/plugins/rbenv-binstubs'
    unless File.exist?(path)
      sh "git clone https://github.com/ianheggie/rbenv-binstubs.git #{path}"
    end
    v = '2.3.1'
    ash "rbenv install #{v}" unless asho('rbenv versions').index(v)
    ash "rbenv global #{v}"
    # GemのGlobalインストール
    ash 'rbenv exec gem install bundle pry-byebug travis --no-document'
    ash 'rbenv exec gem install awesome_print tapp --no-document'
    ash 'rbenv exec gem install rubocop scss_lint --no-document'
    ash 'rbenv rehash'
    ash 'bundle -v' # 代表して確認
    raise 'assert' unless asho('ruby -v').index(v)
  end

  # ----------------------------------------------------------------------
  # Golang
  # ----------------------------------------------------------------------

  l.desc 'goenvを用いてGoをインストールする'
  l.task 'go' => ['goenv', 'build-lib'] do
    v = '1.6'
    ash "goenv install #{v} 2>/dev/null" unless asho('goenv versions').index(v)
    ash "goenv global #{v}"
    ash 'goenv rehash'
    raise 'assert' unless asho('go version').index(v)
  end

  # ----------------------------------------------------------------------
  # Python
  # ----------------------------------------------------------------------

  l.desc 'pyenvを用いてPython2/Python3をインストールする'
  l.task 'python' => ['pyenv', 'build-lib'] do
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

  l.desc 'ndenvを用いてNode.jsをインストールする'
  l.task 'nodejs' => ['ndenv', 'build-lib'] do
    v = '4.4.3'
    ash "ndenv install v#{v}" unless asho('ndenv versions').index(v)
    ash "ndenv global v#{v}"
    ash 'ndenv rehash'
    ash 'npm install -g coffeelint tslint'
    raise 'assert' unless asho('node -v').index(v)
  end

  # ----------------------------------------------------------------------
  # Perl
  # ----------------------------------------------------------------------

  l.desc 'plenvを用いてPerl5とCPANをインストールする'
  l.task 'perl' => ['plenv', 'build-lib'] do
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

  l.desc 'scalaenvを用いてScalaをインストールする'
  l.task 'scala' => ['scalaenv', 'build-lib'] do
    v = '2.11.8'
    ash "scalaenv install scala-#{v}" unless asho('scalaenv versions').index(v)
    ash "scalaenv global scala-#{v}"
    ash 'scalaenv rehash'
    raise 'assert' unless asho('scala -version 2>&1').index(v)
  end

  l.desc 'sbtenvを用いてSBTをインストールする'
  l.task 'sbt' => ['sbtenv', 'build-lib'] do
    v = '0.13.11'
    ash "sbtenv install sbt-#{v}" unless asho('sbtenv versions').index(v)
    ash "sbtenv global sbt-#{v}"
    ash 'sbtenv rehash'
    raise 'assert' unless asho('sbt sbt-version').index(v)
  end

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  l.task 'java' => :fail

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  l.desc 'haskell-stackを用いてHaskell開発環境をインストール'
  l.task 'haskell' => :fail

  # ----------------------------------------------------------------------
  # OCaml
  # ----------------------------------------------------------------------

  l.task 'ocaml' do
    sh 'wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin'
    sh 'eval `opam config env` && opam update'
    sh 'eval `opam config env` && opam upgrade'
    sh 'eval `opam config env` && echo "y" | opam install omake caml2html'
  end

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  l.desc 'アプリケーションを全てインストールする'
  l.task 'applications' => :fail

  l.desc 'Atomのパッケージをインストールする'
  l.task 'atom-packages' do
    atom_packages.each do |pkg|
      sh "apm install #{pkg}"
    end
  end

  # ----------------------------------------------------------------------
  # ドットファイル
  # ----------------------------------------------------------------------

  l.desc 'dotfilesが管理する全dotfileのリンクを張る'
  l.task 'dotfiles' do
    DOTFILE_NAMES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path("./deployed/#{dotfile}")
      next if File.exist?(dotfile_path_home)
      if File.symlink?(dotfile_path_home)
        puts "#{dotfile_path_home}はリンク切れなので削除します."
        rm(dotfile_path_home)
      end
      symlink(dotfile_path_here, dotfile_path_home)
    end
  end

  l.desc 'dotfilesが管理する全dotfileのリンク状態を表示する'
  l.task 'show:dotfiles' do
    width = DOTFILE_NAMES.map(&:size).max
    DOTFILE_NAMES.each do |dotfile|
      status = dotfile_status_colorized(dotfile)
      puts format("~/%-#{width + 2}s # %s", dotfile, status)
    end
  end

  l.desc 'dotfilesが管理する全dotfileのリンクを外す'
  l.task 'remove:dotfiles' do
    DOTFILE_NAMES.each do |dotfile|
      dotfile_path_home = home(dotfile)
      dotfile_path_here = File.expand_path("./deployed/#{dotfile}")
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

  l.desc 'anyenvをインストールする'
  l.task 'anyenv' do
    next if File.exist?(ANY_ENV)
    sh "git clone https://github.com/riywo/anyenv #{ANY_ENV}"
    raise 'assert' unless File.exist?(ANY_ENV)
  end

  l.desc 'anyenvを削除する'
  l.task 'remove:anyenv' do
    next unless File.exist?(ANY_ENV)
    sh "rm -fr #{ANY_ENV}"
    raise 'assert' if File.exist?(ANY_ENV)
  end

  XX_ENV_NAMES = %w(
    rbenv goenv pyenv plenv ndenv scalaenv sbtenv jenv
  ).freeze

  XX_ENV_NAMES.each do |xxenv_name|
    xxenv = home('.anyenv/envs/' + xxenv_name)

    l.desc "anyenvを用いて#{xxenv_name}をインストールする"
    l.task xxenv_name => 'anyenv' do
      next if File.exist?(xxenv)
      ash "anyenv install #{xxenv_name}"
      raise 'assert' if asho("which #{xxenv_name}") == ''
    end

    l.desc "anyenvから#{xxenv_name}を削除する"
    l.task "remove:#{xxenv_name}" do
      next unless File.exist?(xxenv)
      ash "echo y | anyenv uninstall #{xxenv_name}" if File.exist?(xxenv)
      raise 'assert' unless asho("which #{xxenv_name}") == ''
    end
  end

  l.desc 'ビルドに必要なライブラリを一通りインストールする'
  l.task 'build-lib' => :fail
end
