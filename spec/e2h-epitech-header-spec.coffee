E2hEpitechHeader = require '../lib/e2h-epitech-header'

describe "E2hEpitechHeader", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('e2h-epitech-header')

  describe "when the e2h-epitech-header is activated", ->

    it "correctly get the header content from the headerfile", ->
      expect(workspaceElement.querySelector('.e2h-epitech-header')).not.toExist()
      atom.commands.dispatch workspaceElement, 'e2h-epitech-header:AddHeader'

      waitsForPromise ->
        activationPromise

      runs ->
