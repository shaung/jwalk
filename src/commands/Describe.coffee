_ = require 'underscore'
Command = require './Command'

class Describe extends Command

	help: ->
		'examines the schema of an object node'

	autocomplete: (context, str, callback) ->
		return super unless _.isObject(context.pointer)
		keys    = _.keys(context.pointer)
		matches = _.filter keys, (key) -> key.indexOf(str) == 0
		results = if matches.length > 0 then matches else keys
		callback null, [results, str]

	run: (context, args, callback) ->
		
		root = context.pointer
		path = '/' + context.path.join('/')
		try
			subpath = if args? and args[0]? then args[0] else ''
			if subpath.length > 0
				for key in subpath.split('/')
					root = root[key]
					path += key + '/'
		catch error
			console.log "Not an object".red
			console.log error
			callback()
			return

		console.log path

		unless _.isObject(root)
			console.log "Not an object".red
			callback()
			return

		typedesc = (key, obj) ->
			rslt = ""
			summary = ""
			if _.isArray(obj)
				rslt = "array(#{obj.length})"
			else if _.isNumber(obj)
				rslt = "number"
				summary = obj.toString().red
			else if _.isString(obj)
				rslt = "string(#{obj.length})"
				sz = 80
				summary = if obj then '"' + obj.substring(0, sz) + '"' else ''
				summary += '..' if obj.length > sz
			else
				rslt = typeof(obj)
			rslt = rslt.cyan + ' ' + summary.green

		for key in _.keys(root)
			do (key) ->
				value = root[key]
				console.log ' ', key, typedesc(key, value)

		callback()

module.exports = Describe
