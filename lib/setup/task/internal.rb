require 'setup/util'

namespace :internal do
  desc 'Atomのパッケージをインストールする'
  task 'install-atom-package' do
    require 'yaml'
    YAML.load(File.open('./.atom/atom-pkg-list.yml').read).each do |pkg|
      sh "apm install #{pkg}"
    end
  end

  desc 'Caskを用いてEmacsパッケージをインストールする'
  task 'install-emacs-package' do
    cd '.emacs.d' do
      sh "cask init; cask install"
    end
  end
end
