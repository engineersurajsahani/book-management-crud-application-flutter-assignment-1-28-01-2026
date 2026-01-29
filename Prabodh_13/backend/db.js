const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://user:pass@main.n4bbbo4.mongodb.net/');

const db = mongoose.connection;

db.on('connected', () => {
    console.log('Database connected successfully');
});

db.on('disconnected', () => {
    console.log('Database disconnected');
});

db.on('error', (err) => {
    console.log('Database connection error:', err);
});

module.exports = db;