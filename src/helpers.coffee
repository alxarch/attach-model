module.exports = helpers =
	assign_defaults: (base, objects...) ->
		if base? and "object" is typeof base
			for obj in objects when obj? and "object" is typeof obj
				for own key, value of obj when key not of base
					base[key] = value
		base

	ucfirst: (value) -> "#{value[0].toUpperCase()}#{value[1..]}"
	resolve: (obj, attr) ->
		if "function" is typeof attr
			attr obj
		else if Array.isArray attr
			for a in attr
				helpers.resolve obj, a
		else if "Object" is attr?.constructor?.name
			if "$get" of attr
				helpers.pathget obj, attr.$get
			else
				result = {}
				for own key, value of attr
					result[key] = helpers.resolve obj, value
				result
		else
			attr
	pathget: (obj, path) ->
		if obj? and "object" is typeof obj
			for key in path.split /(?:\.|\[|\]\.?)/g when obj?
				obj = obj[key]
		obj
