require 'setup/util'

layer :debian => :common do

  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------
  
  override_task 'build-lib' do
    sh 'sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev'
  end
end
