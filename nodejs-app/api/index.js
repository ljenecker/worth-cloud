'use strict';

const express = require('express');
const bodyParser = require('body-parser');

const MigrateAPI = require('./api/migrate-api');
const PeopleAPI = require('./api/people-api');
const NewsAPI = require('./api/news-api');
const UserAPI = require('./api/user-api');

const app = express();

const MigrateService = require('./services/migrate-service');
const PeopleService = require('./services/people-service');
const NewsService = require('./services/news-service');
const UserService = require('./services/user-service');
const pgp = require('pg-promise')();

require('dotenv').config()

const POSTGRES_HOST= process.env.POSTGRES_HOST
const POSTGRES_PORT= process.env.POSTGRES_PORT
const POSTGRES_USER= process.env.POSTGRES_USER
const POSTGRES_PASSWORD= process.env.POSTGRES_PASSWORD

const DATABASE_URL= `postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/worth`

const config = { 
	connectionString : DATABASE_URL
}

if (process.env.NODE_ENV == 'production') {
	config.ssl = { 
		rejectUnauthorized : false
	}
}

const db = pgp(config);

const migrateService = MigrateService(db);
const peopleService = PeopleService(db);
const newsService = NewsService(db);
const userService = UserService(db);

const migrateAPI = MigrateAPI(migrateService);
const peopleAPI = PeopleAPI(peopleService);
const newsAPI = NewsAPI(newsService);
const userAPI = UserAPI(userService);

var router = express.Router();


app.use(express.static(__dirname + '/app/dist'));

app.use(bodyParser.urlencoded({ extended: false }))

app.use(bodyParser.json())


app.get('/api/migrate', migrateAPI.all);
app.get('/api/people', peopleAPI.all);
app.get('/api/news', newsAPI.all);

app.post('/api/signUp', userAPI.signUp);
app.post('/api/login', userAPI.login);



app.get('/*', function(req, res){
  res.sendFile('app/dist/index.html' ,{root:__dirname});
});

var portNumber = process.env.PORT || 8080;

app.listen(portNumber, function () {
    console.log('Server listening on:', portNumber);
});
