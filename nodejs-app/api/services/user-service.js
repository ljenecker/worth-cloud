const _lodesh = require('lodash');
var jwt = require('jsonwebtoken');
const dayjs = require('dayjs');
let localizedFormat = require('dayjs/plugin/localizedFormat');
const userModel = require('../model/user.model.js');
dayjs.extend(localizedFormat)

module.exports = function userService(db) {
    const getUserNames = async () => {
        let user = await db.manyOrNone('select username from users');
        return user ? user : null;
    }

    const getUserName = async username => {
        let getUser = await db.oneOrNone('select username from users where username = $1', [username]);
        return getUser ? getUser : null;
    }

    const getUserPassword = async (username, password) => {
        let userPassword = await db.oneOrNone('select password from users where username = $1', [username]);
        let pass = await userModel().comparePassword(password, userPassword.password);
        return pass ? true : false;
    }

    const signUp = async (username, password) => {
        let hashPassword = await userModel().cryptPassword(password);
        let validUserName = userModel().usernameIsValid(username);

        console.log(hashPassword);

        if (validUserName === username) {
            await db.none('insert into users (username, password, createdAt, active) values ($1, $2, $3, $4)', [validUserName, hashPassword, dayjs().format('llll'), true]);
            return true
        }
        else {
            console.log(validUserName);
            return validUserName
        }
    }

    const login = async (username, password) => {

        let validUserName = userModel().usernameIsValid(username);

        if (validUserName === username) {
            console.log(validUserName)
            console.log(username)
            let getUsername = await getUserName(username);

            if (getUsername) {
                let pass = await getUserPassword(username, password)

                if (!pass) {
                    throw "Incorrect password";
                }

                const payload = {
                    username: username
                };

                var token = jwt.sign(payload, 'secret', {
                    expiresIn : 60*60*24 // expires in 24 hours
                });

                const data = {
                    token: token
                };

                return data
               
            }else{
                throw "Incorrect usernames";
            }

        } else {
            throw validUserName;
        }

    }

    return {
        getUserNames,
        getUserPassword,
        signUp,
        login,
        getUserName
    }
}