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

class BotViewController: UIViewController ,UITextViewDelegate {

    @IBOutlet weak var botResponseTextView: UITextView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated:Bool)
    {
        super.viewDidAppear(animated)
        botResponseTextView.isSelectable = true
        botResponseTextView.isEditable = false
        botResponseTextView.text = "www.google.com"
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        

        UIApplication.shared.openURL(URL as URL)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
