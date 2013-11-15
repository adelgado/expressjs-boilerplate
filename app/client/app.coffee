global.jade = require('../../vendor/bower/jade/runtime')
global.$ = require('../../vendor/bower/jquery/jquery')
global.jade.helpers = helpers = require('../shared/helpers')
global.jade.client_env = global.app.env

$('html').removeClass('no-js').addClass('js')
$('body').append(app.templates.sample_template())

helpers.log('initialized')
