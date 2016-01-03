{assign_defaults, ucfirst, resolve} = require "./helpers"
NotFoundError = require "./not-found-error"

module.exports = (model, options={}) ->
	options = assign_defaults {}, options,
		where: id: $get: "params.id"
		include: []
		order: []
		multiple: no
		required: yes
		as: model.name
		defaults: null
		errorClass: NotFoundError
		errorMessage: "#{ucfirst model.name} not found"
	
	if options.include and not Array.isArray options.include
		options.include = [options.include]

	(req, res, next) ->
		query_options = {}
		for key in ["where", "include", "order", "limit", "offset"] when key of options
			query_options[key] = resolve req, options[key]

		try
			if options.multiple
				find = model.findAll query_options
			else if options.defaults?
				query_options.defaults = resolve req, options.defaults
				find = model.findCreateFind query_options
					.then ([instance]) -> instance
			else
				find = model.find query_options
		catch err
			return next err

		find.then (result) ->
			if options.required and not options.multiple and not result?
				throw new options.errorClass options.errorMessage
			req[options.as] = result
			next()
		.catch next
