{assign_defaults, ucfirst, resolve} = require "./helpers"
NotFoundError = require "./not-found-error"

module.exports = (model, options={}) ->
	{where, required, multiple, include, as, defaults, errorClass, errorMessage} = assign_defaults {}, options,
		where: (req) -> id: req.params.id
		include: []
		multiple: no
		required: yes
		as: model.name
		defaults: null
		errorClass: NotFoundError
		errorMessage: "#{ucfirst model.name} not found"
	
	unless Array.isArray include
		include = [include]

	(req, res, next) ->
		options =
			include: resolve req, include
			where: resolve req, where

		if multiple
			find = model.findAll options
		else if defaults?
			options.defaults = resolve req, defaults
			find = model.findCreateFind options
				.then ([instance]) -> instance
		else
			find = model.find options

		find.then (result) ->
			if required and not multiple and not result?
				throw new errorClass errorMessage
			req[as] = result
			next()
		.catch next
