const express = require("express");
const cors = require("cors");
require("./database/db");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/books", require("./routes/bookRoutes"));

app.listen(5001, () => {
  console.log(" Server running on port 5001");
});
