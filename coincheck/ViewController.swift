//
//  ViewController.swift
//  coincheck
//
//  Created by 山本　憲 on 2018/09/29.
//  Copyright © 2018年 山本　憲. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let formatter = DateFormatter()
    var lastPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        // Do any additional setup after loading the view, typically from a nib.
        let Timer = Foundation.Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchTicker), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @objc func fetchTicker(){
        let now = Date()
        dateLabel.text = formatter.string(from: now)
        
        Alamofire.request("https://coincheck.com/api/ticker", method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    let json = JSON(response.result.value as Any)
                    print(json)
                    
                    let bid = json["bid"].int!
                    
                    if bid > self.lastPrice {
                        self.view.backgroundColor = UIColor.red
                    } else if bid == self.lastPrice {
                        self.view.backgroundColor = UIColor.white
                    } else {
                        self.view.backgroundColor = UIColor.blue
                    }
                    self.lastPrice = bid
                    self.priceLabel.text = String(bid)
                }
                break
            case .failure(_):
                print(response.result.error as Any)
                break
            }
        }
    }



}

