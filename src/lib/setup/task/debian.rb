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
    sh 'sudo apt-get install oracle-java7-installer'
    sh 'sudo apt-get install oracle-java8-installer'
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

  l.task 'applications' do
    # ctags
    sh 'sudo apt-get install exuberant-ctags'
    # shellcheck
    sh 'sudo apt-get install shellcheck'
  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  l.task 'build-lib' do
    sh 'sudo apt-get install -y build-essential curl'
    sh 'sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev'
    sh 'sudo apt-get install -y libbzip2-dev libsqlite3-dev'
  end
end
