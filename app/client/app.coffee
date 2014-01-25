global.jade = require('jade')
global.$ = require('jquery')
global.jade.helpers = helpers = require('../shared/helpers.coffee')
global.jade.client_env = global.app.env

$('body').append(app.templates.sample_template())

helpers.log('initialized')
