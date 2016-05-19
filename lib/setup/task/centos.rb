require 'setup/util'

layer :centos => :common do

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------
  
  override_task 'build-lib' do
    sh 'sudo yum groupinstall -y "Development Tools"'
    sh 'sudo yum install -y kernel-devel kernel-headers'
  end
end
