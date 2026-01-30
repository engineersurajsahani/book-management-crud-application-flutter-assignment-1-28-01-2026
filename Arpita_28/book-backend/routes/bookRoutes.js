import express from "express";
import Book from "../models/Book.js";

const router = express.Router();

// GET all books
router.get("/", async (req, res) => {
  const books = await Book.find();
  res.json(books);
});

// ADD book
router.post("/", async (req, res) => {
  const book = new Book(req.body);
  await book.save();
  res.status(201).json(book);
});

// UPDATE book
router.put("/:id", async (req, res) => {
  try {
    const updated = await Book.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    if (!updated) {
      return res.status(404).json({ message: "Book not found" });
    }

    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// DELETE book
router.delete("/:id", async (req, res) => {
  try {
    const deleted = await Book.findByIdAndDelete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ message: "Book not found" });
    }
    res.json({ message: "Book deleted" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

export default router;
