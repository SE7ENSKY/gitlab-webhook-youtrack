http = require 'http'
URL = require 'url'

request = require 'request'
request = request.defaults
	method: 'POST'
	json: on

e = encodeURIComponent

module.exports = (url, login, password, callback) ->
	jar = request.jar()
	queryYoutrack = (method, path, cb) ->
		request
			method: method
			url: url + path
			jar: jar
			json: on
		, cb

	queryYoutrack 'POST', "/rest/user/login?login=#{e login}&password=#{e password}", (err, res) ->
		if err
			callback err
		else
			callback null,
				applyCommand: (id, command, comment, runAs = login, cb) ->
					queryYoutrack 'POST', "/rest/issue/#{e id}/execute?command=#{e command}&comment=#{e comment}&runAs=#{e runAs}", (err, res, body) ->
						if err
							cb? err
						else if res.statusCode isnt 200
							cb? new Error 'error applying command to issue'
						else
							cb? null
				issueExists: (id, cb) ->
					queryYoutrack 'GET', "/rest/issue/#{e id}/exists", (err, res, body) ->
						if err
							cb? err
						else if res.statusCode is 200
							cb? null, yes
						else
							cb? null, no
				queryUsers: (q, cb) ->
					queryYoutrack 'GET', "/rest/admin/user?q=#{e q}", (err, res, body) ->
						if err
							cb? err
						else if res.statusCode is 200
							cb? null, body
						else
							cb? null, []
