var app = require("express")();

var server = require("http").createServer(app);

var io = require("socket.io")(server);


io.on("connection",function (socket) {
    console.log("a user connected");

    socket.on('chat message', function(msg){
        console.log('message: ' + msg);
    });

    socket.on("disconnect",function () {
        console.log("user disconnect");
    })
});



// app.get("/",function (req,res) {
//     res.send("hello world")
// });


app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');
});

server.listen(3000,function () {
    console.log("success")
});
