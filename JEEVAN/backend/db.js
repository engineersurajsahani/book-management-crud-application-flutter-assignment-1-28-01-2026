const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://jeevan04:kJSXuy6DmO5X1aIv@cluster0.vlk2gka.mongodb.net/Book_Management?retryWrites=true&w=majority&appName=Cluster0', {
    serverSelectionTimeoutMS: 5000,
}).catch(err => console.log('Connection error:', err));

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