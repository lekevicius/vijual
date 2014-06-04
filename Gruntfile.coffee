module.exports = (grunt) ->

  grunt.initConfig
    clean:
      default:
        src: [ "public" ]

    copy:
      graphics:
        files: [
          {
            expand: true
            src: ['**/*.{png,jpg,gif}']
            cwd: 'public-source/images/'
            dest: 'public/images/'
          },
          {
            expand: true
            src: ['**/*.{png,ico}']
            cwd: 'public-source/icons/'
            dest: 'public/icons/'
          }
        ]
      fonts:
        files: [
          {
            expand: true
            src: ['**/*.otf']
            cwd: 'public-source/fonts/'
            dest: 'public/fonts/'
          }
        ]
      shaders:
        files: [
          {
            expand: true
            src: ['**/*']
            cwd: 'public-source/shaders/'
            dest: 'public/shaders/'
          }
        ]
      resources:
        files: [
          {
            expand: true
            src: ['**/*']
            cwd: 'public-source/resources/'
            dest: 'public/resources/'
          }
        ]
      test:
        files:
          'public/test.html': 'public-source/test.html'
          'public/test/jquery.js': 'public-source/javascripts/libs/jquery-2.1.0.js'
          'public/test/fabric.js': 'public-source/javascripts/libs/fabric-1.4.0.js'

    jade:
      homepage:
        files:
          'public/index.html': 'public-source/index.jade'
          'public/renderer.html': 'public-source/renderer.jade'
      templates:
        options:
          client: true
          globals: ['App', '_']
        files:
          'public-source/javascripts/templates.js': 'public-source/templates/*.jade'

    replace:
      templates:
        src: 'public-source/javascripts/templates.js'
        overwrite: true
        replacements: [
          {
            from: 'public-source/templates/'
            to: ''
          }
        ]

    # glsl_threejs:
    #   shaders:
    #     options:
    #       jsPackage: 'SHADERS'
    #     files:
    #       'public-source/javascripts/shaders.js': ['public-source/shaders/*.vert', 'public-source/shaders/*.frag' ]

    stylus:
      default:
        options:
          compress: false
          linenos: true
          'include css': true
        files:
          'public/css/app.css': 'public-source/stylesheets/app.styl'

    autoprefixer:
      default:
        options:
          browsers: ['last 2 version', 'ie 8', 'ie 9']
        files:
          'public/css/app.css': 'public/css/app.css'

    rig:
      default:
        files:
          'public/js/app.js': 'public-source/javascripts/app.js'


    watch:
      files: ['public-source/**']
      tasks: 'default'
      options:
        livereload:
          port: 9499

    nodemon:
      dev:
        script: 'server.js'
        options:
          ext: 'js,coffee'
          watch: ['./server']
          ignore: [ './node_modules/**', './public/**', './public-source/**' ]

    concurrent:
      options:
        logConcurrentOutput: true
      default:
        tasks: [ 'default', 'watch', 'nodemon' ]

    nodewebkit:
      default:
        options:
          version: '0.9.2'
          build_dir: '../build'
          win: false
        src: [
          './package.json',
          './server.js',
          './public/**/*',
          './server/**/*',
          './node_modules/**/*',
          './plugins/**/*'
        ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-rigger'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-node-webkit-builder'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-glsl-threejs'

  grunt.registerTask 'default', [ 'copy', 'jade', 'replace:templates', 'stylus', 'autoprefixer', 'rig' ]
  grunt.registerTask 'dev', [ 'concurrent' ]
  grunt.registerTask 'frontend', [ 'default', 'watch' ]
  grunt.registerTask 'build', [ 'clean', 'default', 'nodewebkit' ]
