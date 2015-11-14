{assign_defaults, ucfirst, resolve} = require "./helpers"
module.exports = middleware = require "./attach-model"
module.exports.NotFoundError = require "./not-found-error"
module.exports.middleware = middleware
