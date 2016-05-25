# frozen_string_literal: true

CentOSLayer = Layer.new do |l|
  # ----------------------------------------------------------------------
  # ビルドツール
  # ----------------------------------------------------------------------

  l.task 'build-lib' do
    sh 'sudo yum groupinstall -y "Development Tools"'
    sh 'sudo yum install -y kernel-devel kernel-headers'
  end
end
