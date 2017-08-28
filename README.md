## socket.io-Simple-Demo

参照
- [socket.io](https://github.com/socketio/socket.io)
- [socket.io-client-swift](https://github.com/socketio/socket.io-client-swift)



## server端搭建

###### 服务端搭建使用Node.js + Express

- 创建一个空项目**socket**

```
//项目初始化
$ cd socket
$ npm init
```
- 添加依赖
```
//package.json文件
...
"dependencies": {
    "express": "^4.15.4",
    "socket.io": "^2.0.3"
  }
...
```
- 创建主文件（index.js）
```js
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

app.get("/",function (req,res) {
    res.send("hello world")
});

server.listen(3000,function () {
    console.log("success")
});

```

## 浏览器客户端

- 创建客户端页面`index.html`

```html
<!doctype html>
<html>
<head>
    <title>Socket.IO chat</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font: 13px Helvetica, Arial; }
        form { background: #000; padding: 3px; position: fixed; bottom: 0; width: 100%; }
        form input { border: 0; padding: 10px; width: 90%; margin-right: .5%; }
        form button { width: 9%; background: rgb(130, 224, 255); border: none; padding: 10px; }
        #messages { list-style-type: none; margin: 0; padding: 0; }
        #messages li { padding: 5px 10px; }
        #messages li:nth-child(odd) { background: #eee; }
    </style>
</head>
<script src="/socket.io/socket.io.js"></script>
<script src="https://code.jquery.com/jquery-1.11.1.js"></script>
<script>
    $(function () {
        var socket = io();
        $('form').submit(function(){
            socket.emit('chat message', $('#m').val());
            $('#m').val('');
            return false;
        });
    });
</script>
<body>
<ul id="messages"></ul>
<form action="">
    <input id="m" autocomplete="off" /><button>Send</button>
</form>
</body>
</html>
```

- 并修改服务端主文件路由返回`index.html`

```js
app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');
});

```

- 启动服务端


```
$ node index.js
```


- 当使用浏览器访问`http://localhost:3000/`的时候，返回`index.html`页面。当输入文字并点击`send`按钮,服务端收到消息。


## Swift App客户端

- 使用`CocoaPods`导入`Socket.IO-Client-Swift`


```
use_frameworks!

target 'YourApp' do
    pod 'Socket.IO-Client-Swift', '~> 11.1.1' # Or latest version
end
```

- 创建`chatViewController`演示页面,导入`SocketIO`,连接服务端并发送输入框输入的消息。

```swift
import UIKit

import SocketIO
class chatViewController: UIViewController {
    
    var tf = UITextField()
    var socket:SocketIOClient? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket = SocketIOClient(socketURL: URL.init(string: "http://localhost:3000")!, config:  [.log(true), .compress])
        socket!.on(clientEvent: .connect) { (data, ack) in
             print("connect")
        }
        
        socket!.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                self.socket!.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket!.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket!.connect()
        
        self.view.backgroundColor = .white
        
        tf = UITextField.init(frame: CGRect(x: 20, y: 200, width: 300, height: 50))
        tf.borderStyle = .line
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(tf)
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.darkGray
        btn.setTitle("send", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.frame = CGRect(x: 20, y:270 , width: 300, height: 50)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(btn)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func click() {
        print("\(String(describing: tf.text!))")
        socket!.emit("chat message", String(describing: tf.text!))
    }
    
}
```
