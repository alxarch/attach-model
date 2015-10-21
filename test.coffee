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

	it "Handles where arguments", ->
		app.get "/tasks/by-author/john"
		.expect 200
		.then (res) ->
			assert.equal res.body.tasks.length, 3
			for task in res.body.tasks
				assert.equal task.author, "john"
