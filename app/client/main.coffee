# Break out the application running from the configuration definition to
# assist with testing.
require ['config'], ->

  # Kick off the application.
  require [
    'jquery'
    'jade'
    'helpers'
    'templates'
    ], ($, jade, helpers, templates) ->

      jade.helpers = helpers
      jade.client_env = app.env

      $('html').removeClass('no-js').addClass('js')
      $('body').append(templates.sample_template())

      helpers.log('initialized')
