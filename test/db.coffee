Sequelize = require "sequelize"
_ = require "lodash"
os = require "os"
path = require "path"
DB = path.resolve os.tmpdir(), "attach-model-test-#{_.now()}.sqlite"
module.exports = sqlz = new Sequelize "sqlite://#{DB}",
	define: timestamps: no
Author = sqlz.define "Author",
	name:
		type: Sequelize.STRING
		primaryKey: yes
Task = sqlz.define "Task",
	id:
		type: Sequelize.STRING
		primaryKey: yes
	title: Sequelize.STRING
	author: Sequelize.STRING
	created_at: Sequelize.DATE

Task.belongsTo Author,
	foreignKey: "author"
