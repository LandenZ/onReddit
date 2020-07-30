//
//  RedditDetailViewController.swift
//  On Reddit
//
//  Created by Landen 2 Zackery on 7/28/20.
//  Copyright © 2020 stockx. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class RedditDetailViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    var selectedReddit: Reddit?
    
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = selectedReddit?.title
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.navigationDelegate = self
        
        loadWebView()
    }
    
    func loadWebView() {
        guard let link = selectedReddit?.link else { return }
        let urlString = "https://www.reddit.com\(link)"
        guard let myURL = URL(string:urlString) else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @IBAction func reloadWebView(_ sender: Any) {
        loadWebView()
    }
}

//MARK: - WKNavigationDelegate functions
extension RedditDetailViewController: WKNavigationDelegate {
  
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        showErrorMessage()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        showErrorMessage()
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(title: "Ooops something went wrong", message: "The reddit couldn't load, you can try to refresh or try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
