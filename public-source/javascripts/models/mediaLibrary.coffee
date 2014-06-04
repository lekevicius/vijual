class App.MediaLibrary

  setMediaLibrary: (@index) ->

  getByType: (type) -> @index[type] if @index
