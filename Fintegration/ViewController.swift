//
//  ViewController.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/3/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    let entities = [[Entity.init(pred: PredictionResult.Level1, articles: [Article.init(title: "Hedge fund billionaire Julian Robertson on Microsoft, Air Canada, other top ideas", description: "I really like Microsoft. I think its cloud activities and also the new management have brought a revival of Bill Gates' initial strategy. I think that's a great company", url: "http://www.cnbc.com/2016/10/27/hedge-fund-billionaire-julian-robertson-on-microsoft-air-canada-other-top-ideas.html", image: "mic.article.1"), Article.init(title: "Windows 10 Creators Update: all the new features Microsoft didn't mention", description: "Microsoft announced its Creators Update during its press event earlier this week, and a fast-paced video has highlighted a number of new changes.", url: "http://www.theverge.com/2016/10/28/13451846/microsoft-windows-10-creators-update-features", image: "mic.article.2"), Article.init(title: "Microsoft offers Apple users $650 off to trade a MacBook for a Surface", description: "The new Surface Book got lost in the shuffle this week. Understandably so. It did, after all, get third billing at Microsoft’s own event in New York this week, owing to the flashiness of the Surface Studio and Windows 10 Creators Update and all of the 3D content creation that brought with it. And then, of course, Apple happened.", url: "https://techcrunch.com/2016/10/28/microsoft-apple/", image: "mic.article.3")])],
                    [Entity.init(pred: PredictionResult.Level2, articles: [])]]
    
    private var latestQuery: Driver<String> {
        return searchBar.rx.text
            .throttle(0.4, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.hidesWhenStopped = true
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "StockCell", bundle: Bundle.main), forCellReuseIdentifier: "stockCell")
        tableView.rowHeight = 60
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        
        let model = StockInfoSearchViewModel(query: latestQuery)
        searchBar.rx.textDidEndEditing
                    .subscribe(onNext: {self.view.endEditing(true)}, onError: nil, onCompleted: nil, onDisposed: nil)
                    .addDisposableTo(disposeBag)

        
        model.searching
            .drive(activityIndicator.rx.animating)
            .addDisposableTo(disposeBag)
        
        model.cleanStocks
            .drive(tableView.rx.items(cellIdentifier: "stockCell")) { index, model, cell in
                let stoskCell = cell as! StockCell
                stoskCell.stockButton.tag = index
                stoskCell.predictionButton.tag = index
                stoskCell.stockButton.addTarget(self, action: #selector(self.stockButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
                stoskCell.predictionButton.addTarget(self, action:  #selector(self.predictionButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
                stoskCell.stockInfo = model
            }
            .addDisposableTo(disposeBag)
        
        model.errors
            .drive(onNext: { err in
                print("Error \(err)")
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
    }
    
    func predictionButtonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        guard let cell = tableView.cellForRow(at: IndexPath(item: buttonRow, section: 0)) as? StockCell else {
            return
        }
        guard let model = cell.stockInfo?.symbol else {
            return
        }
        self.performSegue(withIdentifier: "prediction", sender: model)
    }
    
    func stockButtonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        guard let cell = tableView.cellForRow(at: IndexPath(item: buttonRow, section: 0)) as? StockCell else {
            return
        }
        guard let model = cell.stockInfo?.symbol else {
            return
        }
        self.performSegue(withIdentifier: "details", sender: model)
    }
    
    //SearchBar stuff
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                tableViewBottomConstraint.constant = keyboardSize.height
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
             let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
                tableViewBottomConstraint.constant = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
        }
    }
    
    //TableView stuff
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "details" {
            let detailsVC = segue.destination as! DetailViewController
            let stock = sender as! String
            detailsVC.stockSymbol = stock
        } else if segue.identifier == "prediction" {
            let predVC = segue.destination as! PredictionViewController
            var entity: [Entity]! = nil
            let model = sender as! String
            predVC.entities = entities[0]

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

