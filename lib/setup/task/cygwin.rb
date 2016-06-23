# frozen_string_literal: true

CygwinLayer = Layer.new do |l|
  l.task 'build-lib' => 'apt-cyg' do
    sh 'apt-cyg install git gcc-core  gcc-g++ make zlib-devel curl'
    sh 'apt-cyg install autoconf libiconv libiconv-devel rsync patch unzip'
    sh 'apt-cyg install openssh openssl-devel'
    sh 'apt-cyg install libxml2-devel libxslt-devel  libffi-devel libgdbm-devel'
  end

  l.desc 'apt-cygをインストールする'
  l.task 'apt-cyg' do
    u = 'https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg'
    sh "wget #{u} -P /bin"
    cd '/bin' do
      sh 'chmod 755 /bin/apt-cyg'
    end
  end

  l.task 'anyenv' do
    raise 'anyenv in cygwin is currently unsupported by this script'
  end
end
