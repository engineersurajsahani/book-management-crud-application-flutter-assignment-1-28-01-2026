import mongoose from "mongoose";

const bookSchema = new mongoose.Schema({
  title: String,
  author: String,
  genre: String,
  price: Number,
  publishedYear: Number,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("Book", bookSchema);
