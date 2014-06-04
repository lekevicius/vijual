class App.Views.Sidebar extends Backbone.View

  template: JST.sidebar
  className: -> "sidebar-block #{ @type } #{ unless @model.get('active') then 'inactive' else '' }"

  initialize: ->
    @type = 'track' if @model instanceof App.Track
    @type = 'object' if @model instanceof App.VO.Base
    _.bindAll @, 'dismissColorPicker', 'applyColor'

    @$el.attr 'data-id', @model.id

    @updateListeners()
    if @type is 'object'
      @listenTo @model, "change:behaviors", @updateListeners
    else
      @listenTo @model, "change:filters", @updateListeners

    if @type is 'track'
      @icon = 'track'
      @opacityKey = 'opacity'
    if @type is 'object'
      @icon = @model.get('type')
      @opacityKey = 'material.opacity'

  events:
    'change .editor-name': 'updateName'
    'click .editor-color': 'pickColor'
    'click .block-header .delete': 'destroyObject'
    'input .opacity-slider': 'updateOpacity'
    'click .activation-toggle': 'toggleActivation'

    'click .behavior-activation-toggle': 'toggleBehaviorActivation'
    'click .delete-behavior': 'deleteBehavior'
    'change .add-new-behavior': 'addBehavior'
    'click .behavior-item.trigger .name': 'triggerBehavior'

    'click .filter-activation-toggle': 'toggleFilterActivation'
    'click .delete-filter': 'deleteFilter'
    'change .add-new-filter': 'addFilter'
    'change .blending-mode': 'updateBlendingMode'

  updateListeners: ->
    @stopListening()
    @listenTo @model, "change:active", @render
    if @type is 'object'
      @listenTo @model, "change:behaviors", @render
      @listenTo behavior, "change:active", @render for behavior in @model.get('behaviors').toArray()
    else
      @listenTo @model, "change:filters", @render
      @listenTo @model, "change:blending", (model, value) => $('.blending-mode').val(value)
      @listenTo filter, "change:active", @render for filter in @model.get('filters').toArray()

  render: ->
    @updateListeners()
    @color = App.colors[ @model.get('editor.color') ]
    @$el.html @template({ model: @model, color: @color, icon: @icon })
    @$el.attr 'class', @className()
    @$el.css 'background-color', App.VUI.colorAlpha(@color, 0.4)
    @$('.block-header, .behavior-header').css 'background-color', App.VUI.colorAlpha(@color, 0.3)

    if @type is 'object'
      @$newBehaviorSelect = @$('select.add-new-behavior')
      @$newBehaviorSelect.append "<option value='new'>Add new behavior...</option>"
      for key, label of {'intro': "Intro Effects", 'outro': "Outro Effects", 'looping': "Continuos Effects", 'beat': "Beat Effects", 'trigger': "Trigger Effects", 'operator': "Operators", 'generator': "Generators" }
        $group = $("<optgroup label='#{ label }' />")
        $group.append "<option value='#{ className }'>#{ name }</option>" for className, name of App.userBehaviorGroups[key]
        @$newBehaviorSelect.append $group
    else
      @$newFilterSelect = @$('select.add-new-filter')
      @$newFilterSelect.append "<option value='new'>Add new filter...</option>"
      @$newFilterSelect.append "<option value='#{ className }'>#{ App.TrackFilters[className].prototype.name }</option>" for className in App.userTrackFilters
      @$('.filter-list').sortable
        appendTo: document.body
        scroll: false
        helper: 'clone'
        distance: 8
        stop: (e, ui) ->
          sorter = 0
          $( '.filter-item', @ ).each (item) ->
            $(@).attr 'data-sorter', sorter
            App.VO.GlobalLookup[ $(@).data('id') ].set('sortOrder', sorter)
            sorter += 1
          App.VO.GlobalLookup[ $(@).closest('.sidebar-block').attr('data-id') ].get('filters').sort()

    @

  updateName: (e) -> @model.set('editor.name', e.target.value)
  updateOpacity: (e) -> @model.set(@opacityKey, e.target.value)

  updateBlendingMode: (e) -> @model.set 'blending', parseInt($(e.target).val())

  addBehavior: (e) ->
    newType = $(e.target).val()
    @model.get('behaviors').add new App.Behaviors[newType]
    @render()
  toggleBehaviorActivation: (e) ->
    uuid = $(e.target).closest('.behavior-item').data('id')
    App.VO.GlobalLookup[uuid].toggleActivation()
    @render()
  triggerBehavior: (e) ->
    uuid = $(e.target).closest('.behavior-item').data('id')
    App.VO.GlobalLookup[uuid].hit()
  deleteBehavior: (e) ->
    uuid = $(e.target).closest('.behavior-item').data('id')
    App.VO.GlobalLookup[uuid].destroy()
    @render()

  addFilter: (e) ->
    newType = $(e.target).val()
    @model.get('filters').add new App.TrackFilters[newType]
    @render()
  toggleFilterActivation: (e) ->
    uuid = $(e.target).closest('.filter-item').data('id')
    filter = App.VO.GlobalLookup[uuid]
    filter.set 'active', not filter.get 'active'
    @render()
  deleteFilter: (e) ->
    uuid = $(e.target).closest('.filter-item').data('id')
    App.VO.GlobalLookup[uuid].destroy()
    @render()

  toggleActivation: ->
    @model.toggleActivation()
    @$el.attr 'class', @className()

  pickColor: (e) ->
    @colorPicker = JST.colorPicker({ current: @color })
    @$el.append @colorPicker
    e.stopPropagation()
    $('.color-picker .color-bubble').on 'click', @applyColor
    $(document).on 'click', @dismissColorPicker

  dismissColorPicker: (e) ->
    $(document).off 'click', @dismissColorPicker
    @$('.color-picker').remove()

  applyColor: (e) ->
    e.stopPropagation()
    @model.set('editor.color', $(e.target).data('id'))
    @render()

  destroyObject: (e) ->
    @model.destroy() # That should also remove object from selection
    App.mainView.renderGrid()
