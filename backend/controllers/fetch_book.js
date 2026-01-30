import Book from "../models/book.js";

export const fetchBooks = async (req, res) => {
    try {
        const books = await Book.find().sort({ createdAt: -1 });
        res.status(200).json(books);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
export default fetchBooks;