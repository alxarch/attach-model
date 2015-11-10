_ = require "lodash"
extract = (obj, extractor) ->
	switch typeof extractor
		when "function"
			extractor obj
		when "object"
			if _.isArray extractor
				_.pick obj, extractor
			else if _.isRegExp extractor
				_.pick obj, (value, key) -> extractor.test key
			else
				result = {}
				for own key, value of extractor
					result[key] = extract obj, value
				result
		else
			_.get obj, extractor

class NotFoundError extends Error
	status: 404
	constructor: (@message) ->
		super
		Error.captureStackTrace @, @


module.exports = (model, options={}) ->
	{where, required, multiple, include, as, defaults, errorClass, errorMessage} = _.defaults {}, options,
		where: (req) -> id: req.params.id
		include: []
		multiple: no
		required: yes
		as: model.name
		defaults: null
		errorClass: NotFoundError
		errorMessage: "#{_.capitalize model.name} not found"

	(req, res, next) ->
		find = do ->
			if multiple
				find = model.findAll
					where: extract req, where
					include: include
			else if defaults?
				find = model.findCreateFind
					where: extract req, where
					include: include
					defaults: extract req, defaults
				.then ([instance]) -> instance
			else
				find = model.find
					where: extract req, where
					include: include

		find.then (result) ->
			if required and not multiple and not result?
				throw new errorClass errorMessage
			req[as] = result
			next()
		.catch next

module.exports.NotFoundError = NotFoundError
module.exports.extract = extract
