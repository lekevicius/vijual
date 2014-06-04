fs = require 'fs'
path = require 'path'
_ = require 'underscore'
exec = require('child_process').exec

class LibraryIndexer
  groupTypes: { images: [ '.png', '.jpg', '.jpeg' ], videos: [ '.mov', '.mp4' ], shapes: [ '.svg' ] }

  constructor: (@path) ->
  read: ->
    @libraryContents = fs.readdirSync @path
    @libraryGroups = { images: [  ], videos: [  ], shapes: [  ] }
    for file in @libraryContents
      unless fs.lstatSync( @path + file ).isDirectory()
        @libraryGroups[ groupType ].push file for groupType, acceptedExtensions of @groupTypes when path.extname(file).toLowerCase() in @groupTypes[ groupType ]

    thumbnailPath = @path + '_vijualThumbnails'
    fs.mkdirSync thumbnailPath unless fs.existsSync thumbnailPath
    for file in @libraryContents
      exec "qlmanage -ti #{ @path + file } -s 40 -o #{ thumbnailPath }", ->

    @libraryGroups

module.exports = LibraryIndexer

