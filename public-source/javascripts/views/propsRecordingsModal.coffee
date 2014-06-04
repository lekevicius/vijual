class App.Views.PropsRecordingsModalView extends Backbone.View
  template: JST.propsRecordingsModal

  initialize: (@control) ->

  play: (e) =>
    recordingNumber = $(e.target).closest('.recording').attr('data-number')
    App.propsConnection.startPlaying @control, recordingNumber

  delete: (e) =>
    recordingNumber = $(e.target).closest('.recording').attr('data-number')
    App.propsConnection.deleteRecording @control, recordingNumber
    e.stopPropagation() # TODO fix bug of deleting, starting from first.

  render: ->
    return $('#propertiesModalBackground').hide() unless @control.values.recordings.length
    @$el.html @template({ recordings: @control.values.recordings })
    @$el.off 'click'
    @$el.on 'click', '.playAction', @play
    @$el.on 'click', '.deleteAction', @delete
    @
