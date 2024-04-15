//
//  WebViewViewController.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 12.04.2024.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    var webSiteUrl:String?
    var webTitle:String?
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWebView()
    }
    
    private func prepareWebView() {
        title=webTitle
        if let urlString = webSiteUrl, let url = URL(string: urlString.withHTTPScheme()) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            showAlert(message: "Geçersiz URL")
        }
    }

    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }


    

}
