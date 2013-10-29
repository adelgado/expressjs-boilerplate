# This is the runtime configuration file. It complements the Gruntfile.js by
# supplementing shared properties.

# WARNING!
# No weird shit here, or retarded requirejs WILL FAIL to compile.
# E.g. no variables (lol)

require.config
  paths:
    vendor: '../vendor'

    # Almond is used to lighten the output filesize.
    almond: '../vendor/bower/almond/almond'

    jquery: '../vendor/bower/jquery/jquery'

    jade: '../vendor/bower/jade/runtime'
    templates: '../../views'
    helpers: '../shared/helpers'

  shim:
    # This is required to ensure Backbone works as expected within the AMD
    # environment.
    backbone:
      # These are the two hard dependencies that will be loaded first.
      deps: ['jquery', 'underscore']
      # This maps the global `Backbone` object to `require('backbone')`.
      exports: 'Backbone'
    chaplin:
      deps: ['backbone']
      exports: 'Chaplin'

    helpers:
      exports: 'helpers'
