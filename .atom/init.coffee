
require './commands/editor.coffee'

atom.keymaps.clear()
atom.keymaps.loadKeymap(atom.getConfigDirPath() + '/keymap.cson', {watch: true})
