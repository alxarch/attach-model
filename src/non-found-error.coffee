module.exports = class NotFoundError extends Error
	status: 404
	constructor: (@message) ->
		super
		Error.captureStackTrace @, @
