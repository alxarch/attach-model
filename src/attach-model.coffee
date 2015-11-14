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
	
	if include and not Array.isArray include
		include = [include]

	(req, res, next) ->
		options = where: resolve req, where
		if include
			options.include = resolve req, include

		try
			if multiple
				find = model.findAll options
			else if defaults?
				options.defaults = resolve req, defaults
				find = model.findCreateFind options
					.then ([instance]) -> instance
			else
				find = model.find options
		catch err
			return next err

		find.then (result) ->
			if required and not multiple and not result?
				throw new errorClass errorMessage
			req[as] = result
			next()
		.catch next
