//
//  ArticleListViewController.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit

protocol ArticleListViewProtocol: class {
    func reloadView()
    func showError(_ text: String)
}

class ArticleListViewController: UIViewController {

    @IBOutlet fileprivate(set) var tableView: UITableView!
    @IBOutlet fileprivate(set) var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate(set) var infoLabel: UILabel!
    private var searchOn: Bool = false
    private var searchController: UISearchController!

    private var viewModel: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = ArticleListViewModel(with: self)
        self.tableView.registerNibOfType(ArticleListTableViewCell.self)
        self.setupSearchController()
    }

    private func setupSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.searchController.searchBar.tintColor = UIColor.black
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.returnKeyType = .search
        self.searchController.searchBar.placeholder = "Enter search text here..."
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    fileprivate func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.infoLabel.isHidden = true
    }

    fileprivate func showLoading(with text: String) {
        self.activityIndicator.startAnimating()
        self.infoLabel.isHidden = false
        self.infoLabel.text = text
    }

}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleForHeader(withSearchOn: self.searchOn)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(searchOn: self.searchOn)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = self.viewModel.articleFor(indexPath.row, withSearchOn: self.searchOn) else {
            return UITableViewCell()
        }
        let cell: ArticleListTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setup(with: article)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let article = self.viewModel.articleFor(indexPath.row, withSearchOn: searchOn) else { return }
        self.navigationController?.pushViewController(ArticleDetailsViewController.controller(for: article), animated: true)
    }
}

extension ArticleListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            self.searchOn = true
            self.showLoading(with: "Loading Articles...")
            self.viewModel.getArticlesFor(searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchOn = false
        self.viewModel.resetDataSource()
    }
}

extension ArticleListViewController: ArticleListViewProtocol {
    func reloadView() {
        self.hideLoading()
        self.tableView.reloadData()
    }

    func showError(_ text: String) {
        self.searchController.searchBar.resignFirstResponder()
        self.hideLoading()
        let errorAlert = UIAlertController(title: "Sorry!", message: text, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true)
    }
}

