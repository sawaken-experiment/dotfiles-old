require 'setup/util'

layer :debian => :common do

  override_task 'remove:all' do

  end

  # ----------------------------------------------------------------------
  # Java
  # ----------------------------------------------------------------------

  ldesc 'Oracle Java7, 8をインストールし、jenvの監視下に置く'
  override_task 'java' => 'jenv' do
    url = 'http://ppa.launchpad.net/webupd8team/java/ubuntu'
    txt = "deb #{url} trusty main\ndeb-src #{url} trusty main\n"
    tmpfile = '.dotfiles-target/java-8-debian.list'
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
    fail 'assert' unless asho("java -version 2>&1").index('1.8')
  end

  # ----------------------------------------------------------------------
  # Haskell
  # ----------------------------------------------------------------------

  override_task 'haskell' do
    next if which 'stack'
    a = 'http://download.fpcomplete.com/debian'
    sh "echo 'deb #{a} jessie main'|sudo tee /etc/apt/sources.list.d/fpco.list"
    sh 'sudo apt-get update && sudo apt-get install stack -y'
  end

  # ----------------------------------------------------------------------
  # アプリケーション
  # ----------------------------------------------------------------------

  override_task 'applications' do

  end

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  override_task 'build-lib' do
    sh 'sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev'
  end
end
