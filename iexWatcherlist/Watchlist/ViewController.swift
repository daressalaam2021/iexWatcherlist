//
//  ViewController.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/2/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ServiceApi.shared.quote.getQuote(with: "AAPL") { (result) in
            switch result {
            case .failure(let error):
                break
            case .success(let quote):
                print(quote)
            }
        }
        
        ServiceApi.shared.quote.getQuotes(with: ["AAPL", "APLE"]) { (result) in
            switch result {
            case .failure(let error):
                break
            case .success(let quotes):
                print(quotes.count)
            }
        }
    }


}

