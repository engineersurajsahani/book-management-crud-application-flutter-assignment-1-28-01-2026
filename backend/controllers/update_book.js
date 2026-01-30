import Book from '../models/book.js';

export const updateBook = async (req, res) => {
    try {
        const { id } = req.params;
        const { title, author, price, genre, publishedYear } = req.body;

        // Find the book by ID and update its details
        const updatedBook = await Book.findOneAndUpdate(
            { id: id },
            { title, author, price, genre, publishedYear },
            { new: true } // Return the updated document
        );

        if (!updatedBook) {
            return res.status(404).json({ message: 'Book not found' });
        }

        res.status(200).json({ message: 'Book updated successfully', book: updatedBook });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
export default updateBook;