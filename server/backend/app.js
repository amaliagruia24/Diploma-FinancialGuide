const express = require("express");
const mongoose = require("mongoose");
const routes = require('./routes/routes');
const body_parser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use('/api', routes);
app.use(body_parser.json());

const mongoString = process.env.DATABASE_URL;


mongoose.connect(mongoString);
const database = mongoose.connection

database.on('error', (error) => {
    console.log(error)
})

database.once('connected', () => {
    console.log('Database Connected');
})


app.listen(3000, () => {
    console.log("Listen on the port 3000...");
});