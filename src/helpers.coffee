module.exports =
	assign_defaults: (base, objects...) ->
		if base? and "object" is typeof base
			for obj in objects when obj? and "object" is typeof obj
				for own key, value of obj when key not of base
					base[key] = value
		base

	ucfirst: (value) -> "#{value[0].toUpperCase()}#{value[1..]}"
	resolve: (req, attr) ->
		if "function" is typeof attr
			attr req
		else if Array.isArray attr
			for a in attr
				resolve req, a
		else if "Object" is attr?.constructor?.name
			result = {}
			for own key, value of attr
				result[key] = resolve req, value
			result
		else
			attr
