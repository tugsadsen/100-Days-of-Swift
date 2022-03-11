//
//  ViewController.swift
//  Project 4
//
//  Created by Tuğşad Şen on 4.03.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "<--", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "-->", style: .plain, target: webView, action: #selector(webView.goForward))
        
        
        

        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh, back, forward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }

    @objc func openTapped() {
       
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
      
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage (action: UIAlertAction) {
        guard let actionTitle = action.title else {return }
        guard let url = URL(string: "https://" + actionTitle) else {return}
        if websites.contains(actionTitle) {
           webView.load(URLRequest(url: url))
        } else {
            let ac = UIAlertController(title: "It's Blocked", message: "The url is isn't allowed.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                } //else {
                    //let warning = UIAlertController(title: "Warning", message: "It's blocked", preferredStyle: .alert)
                    //warning.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    //present(warning, animated: true)
                    
               // }
            }
        }
        decisionHandler(.cancel)
    }
    
}



