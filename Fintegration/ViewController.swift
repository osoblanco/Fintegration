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
        
        let model = StockInfoSearchViewModel(query: latestQuery)
        
        tableView
            .rx.itemSelected
            .subscribe { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
                guard let cell: StockCell = self.tableView.cellForRow(at: indexPath.element!) as? StockCell else {
                    return
                }
                guard let model = cell.stockInfo else {
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "details", sender: model.symbol)
                }
            }
            .addDisposableTo(disposeBag)
        
        model.searching
            .drive(activityIndicator.rx.animating)
            .addDisposableTo(disposeBag)
        
        model.cleanStocks
            .drive(tableView.rx.items(cellIdentifier: "stockCell")) { index, model, cell in
                let stoskCell = cell as! StockCell
                stoskCell.stockInfo = model
            }
            .addDisposableTo(disposeBag)
        
        model.errors
            .drive(onNext: { err in
                print("Error \(err)")
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
//        let tapBackground = UITapGestureRecognizer()
//        tapBackground.rx.event
//            .subscribe(onNext: { [weak self] _ in
//                self?.view.endEditing(true)
//                })
//            .addDisposableTo(disposeBag)
//        view.addGestureRecognizer(tapBackground)
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
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

