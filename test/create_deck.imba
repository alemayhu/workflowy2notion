const path = require('path')
const fs = require('fs')

import DeckHandler from '../src/handlers/DeckHandler'
import ZipHandler from '../src/handlers/ZipHandler'
import ExpressionHelper from '../src/handlers/ExpressionHelper'

import {eq} from './utils'

def test_fixture file_name, deck_name, card_count, files = {}, expectStyle = true
	try
		const file_path = path.join(__dirname, "fixtures", file_name)
		const example = fs.readFileSync(file_path).toString()
		let builder = DeckHandler.new()
		await builder.build(example)

		eq(builder.decks[0].style != undefined, expectStyle, "Style is not set")

		eq(builder.name, deck_name, 'comparing deck names')

		const count = builder.decks.map(do $1.cards.length).reduce(do |lhs, rhs| lhs + rhs)

		eq(count, card_count, 'comparing deck count')

		if card_count > 0
			const o = await builder.apkg()
			eq(o.length > 0, true, 'ensuring output was created')
	catch e
		console.error(e)
		process.exit(1)

def main
	console.time('execution time')
	console.log('Running tests')

	# Testing multiple decks
	await test_fixture('multi-deck-workflowy-export.txt', 'Workflowy 2 Anki', 6, [], false)

	process.exit(0)
	# Single decks
	await test_fixture('pasted.txt', 'List of Scandinavian Countries and Nordic Region', 5, [], false)
	await test_fixture('workflowy-export.opml', 'List of Scandinavian Countries and Nordic Region', 5, [], false)
	await test_fixture('workflowy-export.txt', 'List of Scandinavian Countries and Nordic Region', 5, [], false)
	await test_fixture('workflowy-export.html', 'DNS flashcards', 2)

	console.log('All assertions done 👍🏽')
	console.timeEnd('execution time')
	process.exit(0)

if process.main != module
	main()