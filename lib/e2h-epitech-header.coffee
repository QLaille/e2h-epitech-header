CompositeDisposable = require 'atom'
path = require("path");
fs = require 'fs'

File = 'default-header-file.txt'

module.exports = E2hEpitechHeader =
  modalPanel: null
  subscriptions: null

  activate: ->
    atom.commands.add 'atom-workspace',
      'e2h-epitech-header:addHeader': =>
        @addHeader()

  addHeader: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    if (editor.getPath() && editor)
      @insertHeader(editor)
    else
      atom.confirm
        message: "Cant insert header"
        detailedMessage: "Save your file first, then retry"
        buttons:
          Ok: ->

  generateHeader: (editor) ->
    text = fs.readFileSync(path.resolve(__dirname, File), 'utf8')
    [projectPath, relativePath] = atom.project.relativizePath(editor.buffer.file.path)
    projectPath = projectPath.split "/"

    desc = relativePath + ' file'
    desc = if desc != undefined then desc else 'generic description'
    date = new Date()
    year = date.getFullYear()
    if (date.getMonth() < 9)
      year -= 1

    text = text.replace('%YEAR', year)
    text = text.replace('%DESCRIPTION', desc)
    text = text.replace('%PROJECT_NAME', projectPath[projectPath.length - 1])
    if (relativePath == "Makefile" || editor.getTitle() == "Makefile")
      text = text.replace(/(\*\*)|(\/\*)|(\*\/)/g, '##')

    if (editor != undefined)
      editor.setCursorBufferPosition([0, 0], autoscroll:false)
      editor.insertText(text, select:true)

  hasHeader: (obj) ->
    return @hasHeader(obj.buffer) if obj.buffer?
    @hasHeaderInText(obj.getText())

  hasHeaderInText: (text) ->
    text.match(/.* EPITECH PROJECT.*\r?\n.*\r?\n.* File description.*\r?\n/m)

  insertHeader: (editor) ->
    unless @hasHeader(editor)
      editor.transact =>
        @generateHeader(editor)
