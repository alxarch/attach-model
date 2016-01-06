# attach-model

A middleware to attach Sequelize models to a request

## Usage

```js
var attachModel = require("attach-model");

app.get("/foo/:id", attachModel(models.Foo, {as: "foo", required: true}), function (req, res, next) {
	// req.foo will be the result of models.Foo.find({where: {id: req.params.id}})
	// If required is true an NotFoundError will have been thrown by now.
	res.json(req.foo);
	next()
});
```

### Request parameters

In order to map request parameters to query options, the value of query-related
options (`where`, `include`, `order`, `offset`, `limit`) is searched recursively
for either a `function` value or a `$get` key to retrieve a value 
from the `req` object by path notation. In code:

```js
var options = {
	where: {
		id: {
			$in: {
				$get: "body.ids"
			}
		}
		created_at: {
			$gt: function (req) {
				return req.query ? req.query.since : new Date(0);
			}
		}
	}
};
```

## Options

### options.required

> Boolean default: false

If `true` a `404` response will be returned if no model is found.
If `options.multiple` is `true` this is not applicable.

### options.as

> String default: model name lower case

Request property name for results.

### options.multiple

> Boolean default: false

Will use model.findAll() to to retrieve multiple results

### options.include

> Array[{model, as, ...}]

Include option for sequelize find.
See [request parameters](#request-parameters)

### options.where

> Array {} default: {id: {$get: "params.id"}}

Require option for sequelize find.
See [request parameters](#request-parameters)

### options.errorClass

> Function default: NotFoundError

If `options.multiple` is `true` this is not applicable.

### options.errorMessage

> String default: "Model not found"

If `options.multiple` is `true` this is not applicable.

### options.ttl

> Number default: 0

Cache TTL in seconds for results.

This is a poor man's cache solution storing the resulting Model instances to a POJO.
Use for *small* and frequently accessed result sets to improve performance.

### options.order

> Array[Array[column, order]] default: []

Specify query result order.
See [request parameters](#request-parameters)

### options.limit

> Number default: null

Specify query results limit.
See [request parameters](#request-parameters)

### options.offset

> Number default: 0

Specify query results offset.
See [request parameters](#request-parameters)

