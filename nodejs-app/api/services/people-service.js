module.exports = function PeopleService(db) {
    async function all() {
        const query = `select * from users`;
        let results = await db.manyOrNone(query)
        return results;
    }

    return {
        all
    }
}