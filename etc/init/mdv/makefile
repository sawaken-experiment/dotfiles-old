all:
	sudo pip install markdown
	sudo pip install pygments
	sudo pip install pyyaml
	cd $(HOME)/.build; \
	wget https://github.com/axiros/terminal_markdown_viewer/archive/v0.1.2.tar.gz \
	  -O mdv-0.1.2.tar.gz; \
	tar xvf mdv-0.1.2.tar.gz; \
	cd terminal_markdown_viewer-0.1.2
	echo "alias mdv=\"$(HOME)/.build/terminal_markdown_viewer-0.1.2/mdv.py\"" | cat > ~/.aliases/mdv.alias
