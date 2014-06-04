class App.Views.DocumentToolbar extends Backbone.View

  template: JST.documentToolbar
  events:
    'click .new-render-window': 'createRenderWindow'
    'click .new-props-window': 'createPropsWindow'
    'click .new-scene-window': 'createSceneWindow'
    'click .toggle-stats': 'toggleStats'
    'click .save-file': 'saveFile'
    'click .load-file': 'selectFile'
    'click .new-file': 'resetFile'
    'change .file-uploader': 'loadFile'
    'click .add-object': 'showNewObjectSidebar'
    'mousewheel .bpm-value': (e) ->
      shift = if e.originalEvent.deltaY > 0 then 1 else -1
      $('.bpm-value').val(Math.min( Math.max( parseInt($('.bpm-value').val()) + shift, 1), 300 )).change()
    'change .bpm-value': (e) -> App.ticker.set 'bpm', parseInt($('.bpm-value').val())

  initialize: ->
    Mousetrap.bind 'command+shift+r', (e) ->
      e.preventDefault()
      App.RenderWindow.create()
      return false
    Mousetrap.bind 'command+shift+p', (e) ->
      e.preventDefault()
      App.WindowManager.props()
      return false
    Mousetrap.bind 'command+shift+s', (e) ->
      e.preventDefault()
      App.WindowManager.scene()
      return false

    Mousetrap.bind 'command+s', (e) =>
      e.preventDefault()
      @saveFile()
      return false
    Mousetrap.bind 'command+o', (e) =>
      e.preventDefault()
      @loadFile()
      return false
    Mousetrap.bind 'command+n', (e) =>
      e.preventDefault()
      @resetFile()
      return false

  render: ->
    @$el.html @template()
    @updateButtonStates()
    @

  updateButtonStates: () ->
    $('.toggle-stats').toggleClass 'active', $(App.stats.domElement).is(':visible')
    $('.new-render-window').toggleClass 'active', !! _.size( App.RenderWindow.all )
    $('.new-props-window').toggleClass 'active', !! ( 'props' in App.mainConnection.onlinePeers )
    $('.new-scene-window').toggleClass 'active', !! ( 'scene' in App.mainConnection.onlinePeers )

  createRenderWindow: (e) -> App.RenderWindow.create()
  createPropsWindow: (e) -> App.WindowManager.props()
  createSceneWindow: (e) -> App.WindowManager.scene()

  toggleStats: (e) -> if $(App.stats.domElement).is(':visible') then App.stats.hide() else App.stats.show()

  resetFile: ->
    if window.confirm "Delete current file and start new?"
      App.document.destroy()
      App.resetState()
      App.document = new App.VijualTree JSON.parse(App.emptyDocument)
      App.document.set 'name', ''
      App.mainView = new App.Views.MainView
      App.router.currentView = App.mainView
      console.log 'Reloading main view'
      $('#content').attr('class', 'main').html App.mainView.render().el

  saveFile: (e) ->
    if App.document.get('name') is ''
      App.document.set 'name', prompt("Enter file name", "Untitled")
    blob = new Blob([ JSON.stringify(App.document.toJSON()) ], { type: "application/json;charset=utf-8" })
    saveAs blob, "#{ App.document.get('name') }.vijual"

  selectFile: (e) -> @$('.file-uploader').click()

  loadFile: (e) ->
    file = $('.file-uploader').get(0).files[0]
    reader = new FileReader
    reader.onload = (data) ->
      App.document.destroy()
      App.resetState()
      App.document = new App.VijualTree(JSON.parse(data.target.result))
      App.document.set 'name', file.name.replace(/\.vijual/i, '')

      App.mainView = new App.Views.MainView
      App.router.currentView = App.mainView
      console.log 'Reloading main view'
      $('#content').attr('class', 'main').html App.mainView.render().el

    reader.readAsText file

  showNewObjectSidebar: ->
    App.mainView.showNewObjectSidebar()
