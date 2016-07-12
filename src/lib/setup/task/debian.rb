# frozen_string_literal: true

DebianLayer = Layer.new do |l|
  l.task 'remove:all' do
    nil
  end

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  l.desc 'Oracle Java7, 8をインストールし、jenvの監視下に置く(ダイアログ有り)'
  l.task 'java' => 'jenv' do
    url = 'http://ppa.launchpad.net/webupd8team/java/ubuntu'
    txt = "deb #{url} trusty main\ndeb-src #{url} trusty main\n"
    tmpfile = "#{TARGET_DIR_PATH}/java-8-debian.list"
    sh "echo \"#{txt}\" | cat > #{tmpfile}"
    sh "sudo mv -f #{tmpfile} /etc/apt/sources.list.d/"
    sh 'sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886'
    sh 'sudo apt-get update'
    sh 'sudo apt-get -y install oracle-java7-installer'
    sh 'sudo apt-get -y install oracle-java8-installer'
    ash "echo \"y\ny\ny\n\" | jenv add /usr/lib/jvm/java-7-oracle"
    ash "echo \"y\ny\ny\n\" | jenv add /usr/lib/jvm/java-8-oracle"
    ash 'jenv global 1.8'
    ash 'jenv rehash'
    raise 'assert' unless asho('java -version 2>&1').index('1.8')
  end

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  l.task 'haskell' do
    next if which 'stack'
    a = 'http://download.fpcomplete.com/debian'
    sh "echo 'deb #{a} jessie main'|sudo tee /etc/apt/sources.list.d/fpco.list"
    sh 'sudo apt-get update && sudo apt-get install stack -y --force-yes'
    sh 'stack setup; stack setup'
  end

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  l.task 'applications' => [
    'command-line-tools', 'google-chrome', 'zsh'
  ]

  l.task 'command-line-tools' do
    # ctags
    sh 'sudo apt-get install -y exuberant-ctags'
    # shellcheck
    sh 'sudo apt-get install -y shellcheck'
    # expect
    sh 'sudo apt-get install -y expect'
  end

  l.task 'google-chrome' do
    sh 'wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
    sh 'sudo apt-get update'
    sh 'sudo apt-get -y install libappindicator1'
    sh 'sudo dpkg -i google-chrome-stable_current_amd64.deb'
    sh 'rm google-chrome-stable_current_amd64.deb'
  end

  l.task 'zsh' do
    sh 'sudo apt-get install -y zsh'
    sh 'which zsh'
    sh 'chsh'
    puts 'You need to reboot'
  end

  l.task 'atom' do
    sh 'sudo add-apt-repository ppa:webupd8team/atom'
    sh 'sudo apt-get update'
    sh 'sudo apt-get install -y atom'
  end

  l.task 'vlc' do
    sh 'sudo apt-get update'
    sh 'sudo apt-get install -y vlc'
  end

  # ----------------------------------------------------------------------
  # 環境設定
  # ----------------------------------------------------------------------

  l.task 'swap-ctrl-caps' do
    sh 'dconf reset /org/gnome/settings-daemon/plugins/keyboard/active'
    sh "dconf write /org/gnome/desktop/input-sources/xkb-options \"['ctrl:nocaps']\""
  end

  l.task 'ssh-keygen' do
    next if File.exist?(home('.ssh'))
    sh './etc/auto-keygen.exp'
  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  l.task 'build-lib' do
    sh 'sudo apt-get install -y build-essential curl'
    sh 'sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev'
    sh 'sudo apt-get install -y libbz2-dev libsqlite3-dev'
    sh 'sudo apt-get install -y default-jre'
  end
end
