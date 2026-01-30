import updateBook from "../controllers/update_book.js";
import express from "express";

const router = express.Router();

router.put("/update-book/:id", updateBook);

export default router;
