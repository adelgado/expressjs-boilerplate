jade = require('../../vendor/bower/jade/runtime')
$ = require('../../vendor/bower/jquery/jquery')
helpers = require('../shared/helpers')

global.jade.helpers = helpers

$('html').removeClass('no-js').addClass('js')
$('body').append(app.templates.sample_template())

helpers.log('initialized')
