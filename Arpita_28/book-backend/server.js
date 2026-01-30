import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import bookRoutes from "./routes/bookRoutes.js";

const app = express();

app.use(cors({ origin: "*" }));
app.use(express.json());

// ROUTES
app.use("/api/books", bookRoutes);

// DB
mongoose.connect("mongodb://127.0.0.1:27017/bookdb")
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error(err));

  app.listen(8080, () => {
    console.log("Server running on port 8080");
  });
