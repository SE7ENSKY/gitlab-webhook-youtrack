REGEX = '^(([^#]+)\\s+)?#(\\w+-\\d+)(\\s+(.*))?$'

parseLine = (line) ->
	m = line.match new RegExp REGEX
	if m and m[3]
		result = {}
		result.comment = m[2] if m[2]
		result.id = m[3] if m[3]
		result.command = m[5] if m[5]
		result
	else
		no

parseMessage = (message) ->
	parsedLines = []
	for line in message.split "\n"
		parsedLine = parseLine line
		if parsedLine
			parsedLines.push parsedLine
	parsedLines

module.exports =
	parseMessage: parseMessage
	parseLine: parseLine