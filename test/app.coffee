attachModel = require "../src/index"
db = require "./db"
express = require "express"
supertest = require "supertest-as-promised"
{Task} = db.models
app = express()
app.get "/task/by-title/:title",
	attachModel Task,
		as: "task"
		where: (req) -> title: req.params.title
		defaults: (req) -> title: req.params.title
	(req, res) -> res.json task: req.task

app.get "/tasks/since/:since",
	attachModel Task,
		multiple: yes
		as: "tasks"
		where: (req) -> created_at: $gte: req.params.since
	(req, res) -> res.json tasks: req.tasks

app.get "/tasks/by-author/:name",
	attachModel Task,
		multiple: yes
		as: "tasks"
		where: (req) -> author: req.params.name
	(req, res) -> res.json tasks: req.tasks

app.get "/tasks/:id",
	attachModel Task,
		as: "task"
	(req, res) -> res.json task: req.task

module.exports = agent = supertest app
