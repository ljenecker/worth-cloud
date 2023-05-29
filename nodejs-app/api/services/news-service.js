module.exports = function NewsService(db) {
    async function all() {
        const query = `select * from news`;
        let results = await db.manyOrNone(query)
        return results;
    }
    async function create(news) {
        let data = [
            news.title,
            news.data
        ];
        return await db.none(`insert into news(title, data) 
                    values ($1, $2)`, data)

    }
    async function get(id) {
        let newsResult = await db.oneOrNone('SELECT * FROM news WHERE id = $1', [id])
        return newsResult;
    }

    async function update(news) {
        var data = [
            news.title,
            news.data,
            news.id
        ];

        let updateQuery = `UPDATE news 
            SET title = $1, 
            data = $2, 
            WHERE id = $3`;

        return await db.none(updateQuery, data)

    }

    async function deleteById(id) {
        return await db.none('DELETE FROM news WHERE id = $1', [id])
    }

    return {
        all,
        create,
        delete: deleteById,
        get,
        update
    }
}