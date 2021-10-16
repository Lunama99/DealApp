//
//  WebViewViewController.swift
//  Vera
//
//  Created by Macbook on 24/06/2021.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var stringURL: String = ""
    var webViewTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        title = webViewTitle
        
        DispatchQueue.main.async {
            if let myURL = URL(string: self.stringURL) {
                self.webView.load(URLRequest(url: myURL))
            }
        }
    }
}
