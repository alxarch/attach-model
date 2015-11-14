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

## Options

### options.required

### options.as

### options.multiple

### options.include

### options.where

### options.errorClass

### options.errorMessage
