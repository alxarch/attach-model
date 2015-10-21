moment = require "moment"
module.exports = TASKS = [
	{
		id: "a"
		title: "Task A"
		author: "john"
		created_at: moment.utc().subtract(4, "days").toISOString()
	}
	{
		id: "b"
		title: "Task B"
		author: "john"
		created_at: moment.utc().subtract(2, "days").toISOString()
	}
	{
		id: "c"
		title: "Task C"
		author: "mary"
		created_at: moment.utc().subtract(1, "days").toISOString()
	}
	{
		id: "d"
		title: "Task D"
		author: "john"
		created_at: moment.utc().subtract(1, "hour").toISOString()
	}
]
