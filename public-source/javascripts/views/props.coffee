class App.Views.PropsView extends Backbone.View
  template: JST.props
  events:
    'touchstart': 'loseFocus'
    'click #propertiesModalBackground': -> @$('#propertiesModalBackground').hide()

  showModal: (view) ->
    @currentModalView = view
    modalPanel = $('<div class="propertiesModal"></div>')
    @$('#propertiesModalBackground').html modalPanel
    view.setElement modalPanel
    view.render()
    @$('#propertiesModalBackground').show()

  render: ->
    @$el.html @template()
    @$('#propertiesModalBackground').hide()
    FastClick.attach @$('#propertiesModalBackground').get(0)
    # @$el.find('#properties-grid').append App.VUI.Builder(App.data.demoPanel)
    @

  loseFocus: (e) -> document.activeElement.blur() unless $(e.target).closest('.vui-element').length
