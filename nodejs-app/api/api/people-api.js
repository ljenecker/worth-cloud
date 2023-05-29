module.exports = function(peopleService) {
	
	async function all(req, res) {
		try {
			let results = await peopleService.all(); 
			res.json({
				status: 'success',
				data: results
			});
		}
		catch (err) {
			next(err);
		}
	};

	async function add(req, res) {

		try {
			await peopleService.create({
				category_id: Number(req.body.category_id),
				description : req.body.description,
				price: Number(req.body.price)
			});
			
			res.json({
				status: "success",
			});
		}
		catch (err) {
			res.json({
				status: "error",
				error: err.stack
			});
		}
	};

	async function get(req, res) {
		try {
			let id = req.params.id;
			let product = await peopleService.get(id);
			res.json({
				status: "success",
				data: product
			});
		}
		catch (err) {
			res.json({
				status: "error",
				error: err.stack
			});
		}
	};

	async function update(req, res, next) {
		try{
			await peopleService.update({
				category_id: Number(req.body.category_id),
				description: req.body.description,
				price: Number(req.body.price),
				id: req.params.id
			});
			res.json({
				status: "success"
			});
		}
		catch(err){
			res.json({
				status: "error",
				error: err.stack
			});
		}
	};

	async function deleteProduct (req, res, next) {
		try{
			var id = req.params.id;
			await peopleService.delete(id);
			res.json({
				status: "success"
			});
		}
		catch(err){
			res.json({
				status: "error",
				error: err.stack
			});
		}
	};

	return {
		all,
		add,
		get,
		delete : deleteProduct,
		update
	}
}
