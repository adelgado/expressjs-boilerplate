module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')


    clean:
      build:
        src: 'public/assets'


    coffee:
      compile:
        expand: true
        cwd: 'app/client/'
        src: '**/*.coffee'
        dest: 'public/assets/.tmp/app'
        ext: '.js'


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


    jade:
      views:
        options:
          pretty: true
          compileDebug: false
          client: true
          namespace: 'app.templates'
          amd: true
          processName: (file)-> file.replace(/views\/client\/([\w\/]+).jade/gi, '$1')
        src: 'views/client/**/*.jade'
        dest: 'public/assets/views.js'


    copy:
      vendor:
        src: 'vendor/**'
        dest: 'public/assets/.tmp/'
      shared:
        cwd: 'app/shared/'
        expand: true
        src: '**/*.js'
        dest: 'public/assets/.tmp/shared/'


    # Inspirational reading: https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      compile:
        options:
          baseUrl: 'public/assets/.tmp/app'
          mainConfigFile: 'public/assets/.tmp/app/config.js'

          include: ["main"]
          insertRequire: ["main"]
          findNestedDependencies: true
          name: "almond"
          keepBuildDir: true
          normalizeDirDefines: 'all'

          wrap: true

          out: 'public/assets/app.js'
          optimize: 'none'

          generateSourceMaps: false
          preserveLicenseComments: true
          waitSeconds: 0


    cssmin:
      build:
        src: 'public/assets/app.css'
        dest: 'public/assets/app.min.css'


    uglify:
      app:
        src: 'public/assets/app.js'
        dest: 'public/assets/app.min.js'

    hashify:
      options:
        basedir: 'public/assets/'
        hashmap: 'hashmap.json'

      app_js:
        src: 'public/assets/app.min.js'
        dest: 'app.min.{{hash}}.js'
        key: 'app.js'

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
        ]
        tasks: ['coffee']

      vendor_js:
        files: [
          'vendor/**/*.js'
          'vendor/**/*.coffee'
        ]
        tasks: ['copy:vendor']

      shared_js:
        files: [
          'app/shared/**/*.js'
        ]
        tasks: ['copy:shared']

      app_css:
        files: [
          'css/**/*.css'
          'css/**/*.styl'

          'vendor/**/*.css'
          'vendor/**/*.styl'
        ]
        tasks: ['stylus']

      views:
        files: [
          'views/client/**/*.jade'
          'views/shared/**/*.jade'
        ]
        tasks: ['jade']

      # images:
      #   files: [
      #     'public/images/**/*.jpg'
      #     'public/images/**/*.jpeg'
      #     'public/images/**/*.png'
      #   ]
      #   tasks: ['imagemin']


  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-requirejs')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-hashify')
  grunt.loadNpmTasks('grunt-contrib-compress')
  # grunt.loadNpmTasks('grunt-contrib-imagemin')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', [
    'clean'

    'coffee'
    'stylus'
    'jade'

    'copy'
  ])

  grunt.registerTask('build', [
    'default'

    'requirejs'
    'cssmin'
    'uglify'

    'hashify'

    'compress'
    # 'imagemin' # rely on minification during development
  ])
