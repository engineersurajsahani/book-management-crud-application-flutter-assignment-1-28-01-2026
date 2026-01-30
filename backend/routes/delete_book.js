import { deleteBook } from "../controllers/delete.js";


import express from "express";

const router = express.Router();

router.delete("/delete-book/:id", deleteBook);

export default router;
