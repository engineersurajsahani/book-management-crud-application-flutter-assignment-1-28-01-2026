import Book from "../models/book.js";

export const addBook = async (req, res) => {
  try {
    const { id, title, author, price, genre, publishedYear } = req.body;

    // Validate request body
    if (!id || !title || !author || !price || !genre || !publishedYear) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const newBook = new Book({
      id,
      title,
      author,
      price,
      genre,
      publishedYear,
    });
    await newBook.save();

    res.status(201).json({ message: "Book added successfully", book: newBook });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to add book", details: error.message });
  }
};
