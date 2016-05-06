require 'setup/util'
require 'setup/task/common'
require 'setup/task/osx'

namespace 'test-osx' do
  task 'install-java' => 'osx:install-java' do
    expected_path = ENV['HOME'] + '/.anyenv/envs/jenv/shims/java'
    unless asho('which java').chomp == expected_path
      fail 'test fail'
    end
  end
end

namespace 'test-debian' do

end
