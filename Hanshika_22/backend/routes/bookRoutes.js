const express = require("express");
const router = express.Router();
const Book = require("../models/Book");

// --------------------
// CREATE NEW BOOK
// --------------------
router.post("/", async (req, res) => {
  try {
    const { title, author, genre, price, publishedYear } = req.body;
    if (!title || !author) {
      return res.status(400).json({ error: "Title and Author are required" });
    }

    const newBook = await Book.create({
      title,
      author,
      genre,
      price,
      publishedYear
    });

    res.status(201).json(newBook);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// --------------------
// GET ALL BOOKS
// --------------------
router.get("/", async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 }); // newest first
    res.json(books);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// --------------------
// GET SINGLE BOOK BY ID
// --------------------
router.get("/:id", async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (!book)
      return res.status(404).json({ error: "Book not found" });
    res.json(book);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// --------------------
// UPDATE BOOK BY ID
// --------------------
router.put("/:id", async (req, res) => {
  try {
    const updatedBook = await Book.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true } // return updated document
    );
    if (!updatedBook)
      return res.status(404).json({ error: "Book not found" });
    res.json(updatedBook);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// --------------------
// DELETE BOOK BY ID
// --------------------
router.delete("/:id", async (req, res) => {
  try {
    const deletedBook = await Book.findByIdAndDelete(req.params.id);
    if (!deletedBook)
      return res.status(404).json({ error: "Book not found" });
    res.json({ message: "Book deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
