atom.keymaps.clear()
atom.keymaps.loadKeymap(atom.getConfigDirPath() + '/keymap.cson', {watch: true})


moveColumnHistory = {timeStamp: 0, column: 0}

atom.commands.add 'atom-text-editor', 'user:move-column': (event) ->
  if event
    if event.timeStamp - moveColumnHistory.timeStamp < 1000
      column = moveColumnHistory.column + (event.originalEvent.keyCode - 48)
      b = {timeStamp: 0, keyCode: null}
    else
      column = (event.originalEvent.keyCode - 48) * 10
      b = {timeStamp: event.timeStamp, column: column}
    editor = @getModel()
    dest = [editor.getCursorBufferPosition().row, column]
    editor.setCursorBufferPosition(dest)

markerQueue = {}

atom.commands.add 'atom-text-editor', 'user:mark': (event) ->
  editor = @getModel()
  markerQueue[editor.id] ?= []
  point = editor.getCursorBufferPosition()
  marker = editor.markBufferPosition(point)
  markerQueue[editor.id].push(marker)

atom.commands.add 'atom-text-editor', 'user:unmark': (event) ->
  editor = @getModel()
  markerQueue[editor.id] ?= []
  if marker = markerQueue[editor.id].pop()
    currentPoint = editor.getCursorBufferPosition()
    lastMarkedPoint = marker.getStartBufferPosition()
    editor.setCursorBufferPosition(lastMarkedPoint)
    range = [lastMarkedPoint, currentPoint]
    if event.originalEvent.keyCode == 75 # K
      text = editor.getTextInBufferRange(range)
      editor.setSelectedBufferRange(range)
      editor.delete()
      atom.clipboard.write(text)
    else if event.originalEvent.keyCode == 67 # C
      text = editor.getTextInBufferRange(range)
      atom.clipboard.write(text)

atom.commands.add 'atom-text-editor', 'user:move-row': (envent) ->
  switch event.originalEvent.keyCode
    when 86 # v
      diff = +5
    when 74 # j
      diff = -5
  editor = @getModel()
  currentPoint = editor.getCursorBufferPosition()
  editor.setCursorBufferPosition([currentPoint.row + diff, currentPoint.column])

atom.commands.add 'atom-text-editor', 'user:extended-copy': (event) ->
  editor = @getModel()
  range = editor.getSelectedBufferRange()
  if range.start.isEqual(range.end)
    editor.selectToEndOfLine()
    range = editor.getSelectedBufferRange()
  atom.clipboard.write(editor.getTextInBufferRange(range))
