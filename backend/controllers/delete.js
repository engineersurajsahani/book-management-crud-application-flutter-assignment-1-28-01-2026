import Book from '../models/book.js';

export const deleteBook = async (req, res) => {
    try {
        const { id } = req.params;
        
        const deletedBook = await Book.findOneAndDelete({ id: id });

        if (!deletedBook) {
            return res.status(404).json({ message: 'Book not found' });
        }

        res.status(200).json({ message: 'Book deleted successfully', book: deletedBook });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
}