//
//  ViewController.swift
//  rednitte
//
//  Created by 板垣智也 on 2019/04/09.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         Do any additional setup after loading the view.
        let testObject = PFObject(className: "Testing")
        testObject["foo"] = "bar"
        testObject.saveInBackground(block: {(success, error) in
            print("Object has been saved")
        })
    }


}

