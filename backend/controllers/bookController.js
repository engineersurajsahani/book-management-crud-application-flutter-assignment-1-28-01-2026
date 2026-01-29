const Book = require("../models/Book");


exports.addBook = async (req, res) => {
      console.log("🔥 addBook controller reached");
  console.log(req.body);
  try {
    const book = await Book.create(req.body);
    res.status(201).json({
      success: true,
      message: "Book added successfully",
      data: book,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};


exports.getAllBooks = async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 });
    res.json({
      success: true,
      count: books.length,
      data: books,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getBookById = async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" });
    }
    res.json({ success: true, data: book });
  } catch (error) {
    res.status(400).json({ success: false, message: "Invalid ID" });
  }
};


exports.updateBook = async (req, res) => {
  try {
    const book = await Book.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" });
    }

    res.json({
      success: true,
      message: "Book updated successfully",
      data: book,
    });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};


exports.deleteBook = async (req, res) => {
  try {
    const book = await Book.findByIdAndDelete(req.params.id);
    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" });
    }

    res.json({
      success: true,
      message: "Book deleted successfully",
    });
  } catch (error) {
    res.status(400).json({ success: false, message: "Invalid ID" });
  }
};
