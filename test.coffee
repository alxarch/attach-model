app = require "./test/app"
db = require "./test/db"
{Author, Task} = db.models
assert = require "assert"
TASKS = require "./test/tasks"

describe "attachModel middleware", ->
	before -> db.sync force: yes
	before -> Author.bulkCreate require "./test/authors"
	before -> Task.bulkCreate TASKS

	it "Attaches single instances", ->
		app.get "/tasks/a"
		.expect 200
		.then (res) ->
			assert.deepEqual res.body.task, TASKS[0]

	it "Attaches multiple instances", ->
		app.get "/tasks/since/#{new Date(0).toISOString()}"
		.expect 200
		.then (res) ->
			assert.deepEqual res.body.tasks, TASKS

	it "Attaches multiple instances with offset", ->
		app.get "/tasks/since/#{new Date(0).toISOString()}"
		.query offset: 2
		.expect 200
		.then (res) ->
			assert.equal (TASKS.length - 2), res.body.tasks.length

	it "Attaches multiple instances with limit", ->
		app.get "/tasks/since/#{new Date(0).toISOString()}"
		.query limit: 2
		.expect 200
		.then (res) ->
			assert.equal 2, res.body.tasks.length

	it "Handles where arguments", ->
		app.get "/tasks/by-author/john"
		.expect 200
		.then (res) ->
			assert.equal res.body.tasks.length, 3
			for task in res.body.tasks
				assert.equal task.author, "john"

	it "Handles empty multiple instances", ->
		app.get "/tasks/by-author/sigmund"
		.expect 200
		.then (res) ->
			assert.equal res.body.tasks.length, 0

	it "Responds 404 on missing model", ->
		app.get "/tasks/z"
		.expect 404
