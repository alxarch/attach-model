{noop, md5sum, assign_defaults, ucfirst, resolve} = require "./helpers"
NotFoundError = require "./not-found-error"

module.exports = (model, options={}) ->
	options = assign_defaults {}, options,
		where: id: $get: "params.id"
		include: []
		order: []
		multiple: no
		required: yes
		ttl: 0
		as: model.name
		defaults: null
		errorClass: NotFoundError
		errorMessage: "#{ucfirst model.name} not found"
	
	if options.include and not Array.isArray options.include
		options.include = [options.include]
	
	cache = {}
	ttl = parseInt(options.ttl) or 0
	if ttl > 0
		cacheResult = buildCacheKey = noop
	else
		ttl *= 1000
		buildCacheKey = (query_options) ->
			md5sum JSON.stringify query_options
		cacheResult = (key, result) ->
			if key not of cache
				cache[key] = result
				setTimeout (-> delete cache[key]), ttl
			cache[key]

	(req, res, next) ->
		query_options = _multiple: options.multiple
		for key in ["defaults", "where", "include", "order", "limit", "offset"] when key of options
			query_options[key] = resolve req, options[key]

		cache_key = buildCacheKey query_options

		try
			if ttl > 0 and cache_key of cache
				find = Promise.resolve cache[cache_key]
			else if options.multiple
				find = model.findAll query_options
			else if options.defaults?
				find = model.findCreateFind query_options
					.then ([instance]) -> instance
			else
				find = model.find query_options
		catch err
			return next err

		find.then (result) ->
			cacheResult cache_key, result
			if options.required and not options.multiple and not result?
				throw new options.errorClass options.errorMessage
			req[options.as] = result
			next()
		.catch next
