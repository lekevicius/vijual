class App.VijualTree extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany
    key: 'tracks'
    relatedModel: 'App.Track'
    collectionOptions: {
      comparator: 'trackNumber'
    }
    reverseRelation: {
      type: Backbone.HasOne
      key: 'document'
      includeInJSON: false
    }
  },
  {
    type: Backbone.HasMany
    key: 'selectedObjects'
    relatedModel: 'App.VO.Base'
  }]

  defaults:
    name: ''
    selectedTrack: 0

  destroy: ->
    track.destroy() for track in @get('tracks').toArray()
    super

App.VijualTree.setup()
