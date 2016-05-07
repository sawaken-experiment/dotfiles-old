require 'setup/util'

namespace 'test-common' do
  xxenv_languages = [
    ['ruby', 'rbenv'],
    ['perl', 'plenv'],
    ['scala', 'scalaenv'],
    ['python', 'pyenv'],
  ]
  xxenv_languages.each do |lang, env|
    task "install-#{lang}" => "common:install-#{lang}" do
      expected_path = home("/.anyenv/envs/#{env}/shims/#{lang}")
      unless asho("which #{lang}").chomp == expected_path
        fail 'test fail'
      end
    end
  end

  task 'install-dotfiles' => 'common:install-dotfiles' do
    expected_path = File.expand_path('.zshenv')
    unless `readlink #{home('.zshenv')}`.chomp == expected_path
      fail 'test fail'
    end
  end
end

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
