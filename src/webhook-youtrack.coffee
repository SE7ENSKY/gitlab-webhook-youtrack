commitParser = require './commit-parser'
async = require 'async'

module.exports = (app) ->
	makeYoutrackClient = (cb) ->
		require('./youtrack-client') app.get('youtrack url'), app.get('youtrack login'), app.get('youtrack password'), cb
	
	(req, res, next) ->
		makeYoutrackClient (err, youtrackClient) ->
			if err
				next err
			else
				if req.body?.total_commits_count? > 0
					async.eachSeries req.body.commits, (commit, doneCommit) ->
						console.log 'Commit'
						console.dir commit
						parsedCommands = commitParser.parseMessage commit.message
						if parsedCommands
							async.eachSeries parsedCommands, (parsedCommand, doneCommand) ->
								console.log 'Command'
								console.dir parsedCommand
								youtrackClient.queryUsers commit.author.email, (err, users) ->
									runAs = if users.length is 1
										users[0].login
									else
										app.get('youtrack login')
									command = parsedCommand.command or ''
									comment = """
										#{if parsedCommand.comment then "#{parsedCommand.comment}\n" else ''}Commit [#{commit.url} #{commit.id}] made by #{commit.author.name} <#{commit.author.email}> on #{commit.timestamp}
										{quote}#{commit.message}{quote}
									"""
									youtrackClient.applyCommand parsedCommand.id, command, comment, runAs, doneCommand
							, doneCommit
						else
							doneCommit()
					, (err) ->
						if err
							next err
						else
							res.send 'ok'
