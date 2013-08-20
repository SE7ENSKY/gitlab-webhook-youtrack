express = require 'express'
http = require 'http'

app = express()
app.configure ->
	app.enable 'trust proxy'
	app.set 'port', process.env.PORT or 3000
	app.set 'youtrack url', process.env.YOUTRACK_URL or 'http://localhost'
	app.set 'youtrack login', process.env.YOUTRACK_LOGIN or 'root'
	app.set 'youtrack password', process.env.YOUTRACK_PASSWORD or 'root'

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.logger('dev')
app.use app.router
app.use (err, req, res, next) ->
	console.error err.stack
	if req.xhr
		res.send 500,
			error: 'Something blew up!'
	else
		next err

app.get '/', (req, res, next) ->
	res.send """
		GitLab Webhook for Youtrack.
		https://github.com/Se7enSky/gitlab-webhook-youtrack\n
	"""

app.post '/gitlab-youtrack', require('./src/webhook-youtrack')(app)

server = http.createServer app
server.listen app.get('port'), ->
	console.log "GitLab Webhook for Youtrack (#{app.get('youtrack url')}) listening on port #{app.get('port')}"
