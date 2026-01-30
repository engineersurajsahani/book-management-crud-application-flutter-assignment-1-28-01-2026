import express from "express";
import connectDB from "./config/db.js";
import addBookRoutes from "./routes/add_book.js";
import fetchBookRoutes from "./routes/fetch_book.js";
import updateBookRoutes from "./routes/update_book.js";
import deleteBookRoutes from "./routes/delete_book.js";
import cors from "cors";

// Connect to the database

const app = express();
const PORT = 3000;

// Use built-in body parsing middleware
app.use(express.json());
connectDB();

// Enable CORS
app.use(cors());

app.get("/", (req, res) => {
  res.send("Welcome to the Book Management CRUD Application API");
});

// Register routes
app.use("/", addBookRoutes);
app.use("/", fetchBookRoutes);
app.use("/", updateBookRoutes);
app.use("/", deleteBookRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
