import Book from "../models/Book.js";

export const addBook = async (req, res) => {
  try {
    const book = await Book.create(req.body);
    res.status(201).json(book);
  } catch (e) {
    res.status(400).json({ msg: e.message });
  }
};

export const getBooks = async (req, res) => {
  res.json(await Book.find());
};

export const getBook = async (req, res) => {
  res.json(await Book.findById(req.params.id));
};

export const updateBook = async (req, res) => {
  res.json(await Book.findByIdAndUpdate(req.params.id, req.body, { new: true }));
};

export const deleteBook = async (req, res) => {
  await Book.findByIdAndDelete(req.params.id);
  res.json({ msg: "Book Deleted" });
};
