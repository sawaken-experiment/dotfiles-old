SCALAVER="2.11.7"
SBTVER="0.13.9"

zsh:
	sudo apt-get install -y zsh
	which zsh
	chsh

rbenv:
	sudo apt-get update
	sudo apt-get install -y build-essential
	sudo apt-get install -y git
	git clone https://github.com/sstephenson/rbenv.git $(HOME)/.rbenv
	git clone https://github.com/sstephenson/ruby-build.git $(HOME)/.rbenv/plugins/ruby-build
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $(HOME)/.zshrc
	echo 'eval "$(rbenv init -)"' >> $(HOME)/.zshrc
	rbenv install 2.1.2
	rbenv install 2.0.0-p576
	rbenv install 1.9.3-p547
	rbenv global 2.1.2

scala:
	sudo apt-get remove -y scala-library scala
	sudo wget www.scala-lang.org/files/archive/scala-$(SCALAVER).deb
	sudo dpkg -i scala-$(SCALAVER).deb
	sudo apt-get update
	sudo apt-get install -y scala

sbt:
	sudo wget https://bintray.com/artifact/download/sbt/debian/sbt-$(SBTVER).deb
	sudo dpkg -i sbt-$(SBTVER).deb
	sudo apt-get update
	sudo apt-get install -y sbt
