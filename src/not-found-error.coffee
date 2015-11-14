class NotFoundError extends Error
	module.exports = @
	status: 404
	constructor: (@message) ->
		super
		Error.captureStackTrace @, @
