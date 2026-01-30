import mongoose from "mongoose";

const { Schema } = mongoose;

const bookSchema = new Schema(
  {
    id: { type: String, required: true, unique: true },
    title: { type: String, required: true, trim: true },
    author: { type: String, required: true, trim: true },
    price:{ type: Number, required: true },
    genre:{ type: String, required: true, trim: true },
    publishedYear: { type: Number, required: true },
  },
  { timestamps: true },
);

const Book = mongoose.models.Book || mongoose.model("Book", bookSchema);
export default Book;
