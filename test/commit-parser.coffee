describe 'commitParser', ->
	commitParser = null
	it 'should be', ->
		commitParser = require '../src/commit-parser'
		commitParser.should.be.object
	it 'should contain parseMessage and parseLine functions', ->
		commitParser.parseMessage.prototype.should.be.function
		commitParser.parseLine.prototype.should.be.function

	describe '#parseLine', ->
		allTests =
			'simple mention':
				'#ISSUE-1': { id: 'ISSUE-1' }
				'#7A-51': { id: '7A-51' }
				'#A7-999': { id: 'A7-999' }
				'#R2D2-990': { id: 'R2D2-990' }
			'with comment only':
				'1 #AA-11': { id: 'AA-11', comment: '1' }
				'simple comment #AA-11': { id: 'AA-11', comment: 'simple comment' }
				'текст українською #AA-11': { id: 'AA-11', comment: 'текст українською' }
			'with command only':
				'#AA-11 Open': { id: 'AA-11', command: 'Open' }
				'#AA-11 For review': { id: 'AA-11', command: 'For review' }
				'#AA-11 Won\'t fix work 1h30m': { id: 'AA-11', command: 'Won\'t fix work 1h30m' }
			'with comment and command':
				'Weird error happen! #AA-11 Won\'t fix work 1h30m': { id: 'AA-11', comment: 'Weird error happen!', command: 'Won\'t fix work 1h30m' }
				'fixed #BUG-666 Fixed work 1m': { id: 'BUG-666', command: 'Fixed work 1m', comment: 'fixed' }

		createTest = (line, expectedResult) ->
			->
				commitParser.parseLine(line).should.eql(expectedResult)

		for heading, tests of allTests
			describe heading, ->
				for line, expectedResult of tests
					it line, createTest line, expectedResult

	describe '#parseMessage', ->
		allTests =
			'simple mentions':
				"#ISSUE-1": [{ id: 'ISSUE-1' }]
				"#7A-51\n\n": [{ id: '7A-51' }]
				"\n#A7-999\n#ISSUE-1": [{ id: 'A7-999' }, { id: 'ISSUE-1' }]
			'complex test':
				"\n#ISSUE-1\nтекст українською #AA-11\n\nWeird error happen! #AA-11 Won\'t fix work 1h30m\n\n\n#ISSUE-1\n": [
					{ id: 'ISSUE-1' }
					{ id: 'AA-11', comment: 'текст українською' }
					{ id: 'AA-11', comment: 'Weird error happen!', command: 'Won\'t fix work 1h30m' }
					{ id: 'ISSUE-1' }
				]

		createTest = (message, expectedResult) ->
			->
				commitParser.parseMessage(message).should.eql(expectedResult)

		for heading, tests of allTests
			describe heading, ->
				for message, expectedResult of tests
					it message.replace(///\n///g, '\\n'), createTest message, expectedResult