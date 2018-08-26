//
//  ArticleDetailsViewController.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 26/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit
import WebKit

protocol ArticleDetailsViewProtocol: class {
    func showInfo(_ text: String)
}

class ArticleDetailsViewController: UIViewController {

    private var viewModel : ArticleDetailsViewModel!
    @IBOutlet fileprivate(set) var webView: WKWebView!
    @IBOutlet fileprivate(set) var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bookmarkBarButton: UIBarButtonItem!

    static func controller(for article: WikiPage) -> ArticleDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
        let viewModel = ArticleDetailsViewModel(with: controller, andArticle: article)
        controller.viewModel = viewModel
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.viewModel.article.title
        if !self.viewModel.shouldShowBookmarkButton() {
            self.navigationItem.rightBarButtonItem = nil
        }
        self.setupWebView()
    }

    private func setupWebView() {
        guard let articleRequest = self.viewModel.requestToLoad() else {
            self.showInfo("Could not load article")
            return
        }
        self.webView.navigationDelegate = self
        self.webView.load(articleRequest)
    }
    
    @IBAction func bookmarkActionTapped(_ sender: Any) {
        self.viewModel.saveArticle()
    }
}

extension ArticleDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let redirectedURL: String = webView.url?.absoluteString {
            let lowerBound = String.Index(encodedOffset: WikiDetailEndpoint.count)
            let upperBound = String.Index(encodedOffset: redirectedURL.count)
            let title = String(redirectedURL[lowerBound..<upperBound]).replacingOccurrences(of: "_", with: " ")
            self.navigationItem.title = title
        }
        self.activityIndicator.startAnimating()
    }
}

extension ArticleDetailsViewController: ArticleDetailsViewProtocol {
    func showInfo(_ text: String) {
        let errorAlert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true)
    }
}
