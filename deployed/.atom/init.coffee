#
# require './commands/editor.coffee'
# require './commands/rspec.coffee'
#
# atom.keymaps.clear()
# atom.keymaps.loadKeymap(atom.getConfigDirPath() + '/keymap.cson', {
#   watch: true
# })
#
# atom.commands.add 'atom-text-editor', 'user:hoge', (event) ->
#   console.log atom.keymaps.findKeyBindings
#     keystrokes: 'ctrl-a'
#     target: atom.views.getView(@getModel())
