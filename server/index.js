//import from package
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const adminRouter = require("./routes/admin");
//import other file
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

//init
const PORT = 3000;
const app = express();
const DB =
 "mongodb+srv://anhngocthiduong:dacn123@cluster0.atjpxe0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";


//middleware
// client =>middleware => server =>client
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

//Connections
mongoose.connect(DB).then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT,() => {
    console.log('connected at port '+ PORT);

});



