//
//  chatViewController.swift
//  mvcFrame
//
//  Created by 刘洋 on 2017/8/28.
//  Copyright © 2017年 LY. All rights reserved.
//

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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
