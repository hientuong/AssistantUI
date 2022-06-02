//
//  ViewController.swift
//  AssistantUI
//
//  Created by cong nguyen on 06/01/2022.
//  Copyright (c) 2022 cong nguyen. All rights reserved.
//

import UIKit
import AssistantUI

class ViewController: UIViewController {
    @IBOutlet weak var lblText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Assistant.shared.start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

