module.exports = function MigrateService(db) {
  async function all() {
    let query = `DROP TABLE IF EXISTS users;`;

    await db.none(query);

    query = `DROP TABLE IF EXISTS news;`;

    await db.none(query);

    query = `create table users (
            id serial not null primary key,
            username text unique not null,
            password text not null,
            role text not null
        );`;

    await db.none(query);

    query = `create table news (
            id serial not null primary key,
            title text unique not null,
            data text not null
        );`;

    await db.none(query);

    let data = [
      "alice",
      "$2b$10$h6XV5kUuR386DsgHLN2IPeQ51vzOA.Yy6/WeJR1g/I3hjX44.mp4u",
      "MARKETING",
    ];

    await db.none(
      `insert into users(username, password, role) 
                    values ($1, $2, $3)`,
      data
    );

    data = [
      "malory",
      "$2b$10$h6XV5kUuR386DsgHLN2IPeQ51vzOA.Yy6/WeJR1g/I3hjX44.mp4u",
      "MARKETING",
    ];

    await db.none(
      `insert into users(username, password, role) 
                    values ($1, $2, $3)`,
      data
    );

    data = [
      "bobby",
      "$2b$10$h6XV5kUuR386DsgHLN2IPeQ51vzOA.Yy6/WeJR1g/I3hjX44.mp4u",
      "EDITOR",
    ];

    await db.none(
      `insert into users(username, password, role) 
                    values ($1, $2, $3)`,
      data
    );

    data = [
      "charlie",
      "$2b$10$h6XV5kUuR386DsgHLN2IPeQ51vzOA.Yy6/WeJR1g/I3hjX44.mp4u",
      "HR",
    ];

    await db.none(
      `insert into users(username, password, role) 
                    values ($1, $2, $3)`,
      data
    );

    data = [
      "Cape Town named best city in a new ranking",
      "New York and Paris are close behind in 2nd and 3rd among 100 cities in the ranking",
    ];

    await db.none(
      `insert into news(title, data) 
                    values ($1, $2)`,
      data
    );

    data = [
      "What an amazing piece describing SA",
      "I sit here quietly thinking about what it means to me to be South African, a visitor to South Africa or even African",
    ];

    return await db.none(
      `insert into news(title, data) 
                    values ($1, $2)`,
      data
    );
  }

  return {
    all,
  };
};
