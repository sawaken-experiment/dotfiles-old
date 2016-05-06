require 'setup/util'
require 'setup/task/common'
require 'setup/task/osx'

namespace 'test-osx' do
  task 'install-java' => 'osx:install-java' do
    unless `which java`.chomp == '/Users/sawada/.anyenv/envs/jenv/shims/java'
      fail 'test fail'
    end
  end
end
