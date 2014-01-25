module.exports = (grunt) ->
  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')


    clean:
      build:
        src: 'public/assets'


    browserify:
      options:
        transform: ['coffeeify']
        alias: [
          'vendor/bower/jade/runtime.js:jade'
        ]
        shim:
          jquery:
            path: 'vendor/bower/jquery/jquery'
            exports: '$'
          # underscore:
          #   path: 'vendor/bower/lodash/dist/lodash.underscore'
          #   exports: '_'
          # backbone:
          #   path: 'vendor/bower/backbone/backbone'
          #   exports: 'Backbone'
      app:
        src: 'app/client/app.coffee'
        dest: 'public/assets/app.js'


    stylus:
      app:
        options:
          compress: false
          'include css': true
          urlfunc: 'embedurl'
          linenos: true
          define:
            '$version': '<%= pkg.version %>'
        src: 'css/app.styl'
        dest: 'public/assets/app.css'

      static:
        options:
          compress: false
          'include css': true
          urlfunc: 'embedurl'
          linenos: true
          define:
            '$version': '<%= pkg.version %>'
        src: 'css/static.styl'
        dest: 'public/static.css'


    jade:
      views:
        options:
          pretty: true
          compileDebug: false
          client: true
          namespace: 'app.templates'
          processName: (file)-> file.replace(/views\/client\/([\w\/]+).jade/gi, '$1')
        src: 'views/client/**/*.jade'
        dest: 'public/assets/views.js'

      static:
        options:
          pretty: true
          compileDebug: false

        expand: true
        cwd: 'views/static'
        src: ['**/*.jade', '!**/_*.jade']
        dest: 'public'
        ext: '.html'


    cssmin:
      app:
        src: 'public/assets/app.css'
        dest: 'public/assets/app.min.css'

      static:
        src: 'public/static.css'
        dest: 'public/static.css'


    uglify:
      app:
        src: 'public/assets/app.js'
        dest: 'public/assets/app.min.js'

      views:
        src: 'public/assets/views.js'
        dest: 'public/assets/views.min.js'


    hashify:
      options:
        basedir: 'public/assets/'
        hashmap: 'hashmap.json'

      app_js:
        src: 'public/assets/app.min.js'
        dest: 'app.min.{{hash}}.js'
        key: 'app.js'

      views_js:
        src: 'public/assets/views.min.js'
        dest: 'views.min.{{hash}}.js'
        key: 'views.js'

      app_css:
        src: 'public/assets/app.min.css'
        dest: 'app.min.{{hash}}.css'
        key: 'app.css'


    compress:
      build:
        options:
          mode: 'gzip'
        expand: true
        src: 'public/assets/*.min.*.*'
        dest: './'


    # imagemin:
    #   options:
    #     optimizationLevel: 7
    #   files:
    #     expand: true
    #     src: [
    #       'public/images/**/*.jpg'
    #       'public/images/**/*.jpeg'
    #       'public/images/**/*.png'
    #     ]
    #     dest: './'


    watch:
      options:
        spawn: false
        interrupt: true
        dateFormat: (time) ->
          grunt.log.writeln("Compiled in #{time}ms @ #{(new Date).toString()} 💪\n")

      app_js:
        files: [
          'app/client/**/*.coffee'
          'app/shared/**/*.coffee'
          'vendor/**/*.js'
          'vendor/**/*.coffee'
        ]
        tasks: ['browserify']

      css:
        files: [
          'css/**/*.styl'
          'vendor/**/*.css'
          'vendor/**/*.styl'
        ]
        tasks: ['stylus:app']

      views:
        files: [
          'views/client/**/*.jade'
          'views/shared/**/*.jade'
        ]
        tasks: ['jade:views']

      static:
        files: [
          'views/static/**/*.jade'
        ]
        tasks: ['jade:static']

      # images:
      #   files: [
      #     'public/images/**/*.jpg'
      #     'public/images/**/*.jpeg'
      #     'public/images/**/*.png'
      #   ]
      #   tasks: ['imagemin']


  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-browserify')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-hashify')
  grunt.loadNpmTasks('grunt-contrib-compress')
  # grunt.loadNpmTasks('grunt-contrib-imagemin')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', [
    'clean'

    'browserify'
    'stylus'
    'jade'
  ])

  grunt.registerTask('build', [
    'default'

    'cssmin'
    'uglify'

    'hashify'

    'compress'
    # 'imagemin' # rely on minification during development
  ])
