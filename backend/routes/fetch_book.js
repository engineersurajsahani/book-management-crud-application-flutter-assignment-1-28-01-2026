import fetchBooks from "../controllers/fetch_book.js";
import express from "express";

const router = express.Router();

router.get("/fetch-books", fetchBooks);

export default router;
