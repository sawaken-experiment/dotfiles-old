# frozen_string_literal: true

module TopUtilFunction
  module_function

  def atom_packages
    require 'yaml'
    YAML.load(File.open(ENV['HOME'] + '/.atom/atom-pkg-list.yml').read)
  end

  def home(path)
    ENV['HOME'] + '/' + path
  end

  def which(bin)
    res = `which #{bin}`
    res == '' ? nil : res
  end

  def dotfile_status(dotfile_name)
    dotfile_path_home = home(dotfile_name)
    dotfile_path_here = File.expand_path("./deployed/#{dotfile_name}")
    raise unless dotfile_path_here
    if File.exist?(dotfile_path_home)
      link_dest = `readlink #{dotfile_path_home}`.chomp
      if link_dest == dotfile_path_here
        { :status => :ok, :desc => 'linked from dotfiles' }
      elsif link_dest == ''
        { :status => :warning, :desc => 'entity (the file is not a symlink)' }
      else
        { :status => :warning, :desc => "linked from the other (#{link_dest})" }
      end
    else
      { :status => :error, :desc => 'unlinked (the file does not exist)' }
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
    paths = ENV['PATH'].split(':')
    paths.push(path)
    ENV['PATH'] = paths.uniq.join(':')
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
  def ash(command, &proc)
    shift_path("#{ENV['HOME']}/.anyenv/bin")
    sh('eval "$(anyenv init -)"; ' + command, &proc)
  end

  def asho(command)
    shift_path("#{ENV['HOME']}/.anyenv/bin")
    `eval "$(anyenv init -)"; #{command}`
  end

  # Progress出力を無効化し, 出力容量を抑える.
  # brewの出力が大きくてTravisCIでログ容量上限を超過したのでその対策.
  def shq(command)
    sh command + ' | cat'
  end

  # windows版sh(command)関数
  # windowsではsh(comamnd)は動かないようなので.
  def wsh(command)
    puts command
    puts `#{command}`
  end

  def check_path(path)
    raise "#{path} does not exist" unless File.exist?(path)
    path
  end
end

extend TopUtilFunction

# travisCIではclone先が$HOME/dotfilesではないことに注意
# $HOME/build/username/dotfilesになる模様.
DOTFILES_DIR_PATH = check_path(File.expand_path('../../../../', __FILE__))
DOTFILE_NAMES = Dir.glob('./deployed/.*[^~#.]').map { |f| File.basename(f) }
TARGET_DIR_PATH = check_path(DOTFILES_DIR_PATH + '/target')
