//
//  BotViewController.swift
//  Fintegration
//
//  Created by Hrach on 10/28/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class BotViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var responseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
