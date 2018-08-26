//
//  ArticleListViewModel.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit

class ArticleListViewModel {

    private weak var articleListView: ArticleListViewProtocol?
    private var articleDataSource: [WikiPage] = [] {
        didSet {
            self.articleListView?.reloadView()
        }
    }
    private var savedArticlesDataSource: [WikiPage] = []

    required init(with view: ArticleListViewProtocol) {
        self.articleListView = view
        self.getSavedArticles()
        NotificationCenter.default.addObserver(self, selector: #selector(getSavedArticles), name: ArticleSaveNotification, object: nil)
    }

    func numberOfRows(searchOn: Bool) -> Int {
        let articleDataSource = searchOn ? self.articleDataSource : self.savedArticlesDataSource
        return articleDataSource.count
    }

    func articleFor(_ row: Int, withSearchOn searchOn: Bool) -> WikiPage? {
        let articleDataSource = searchOn ? self.articleDataSource : self.savedArticlesDataSource
        guard row < articleDataSource.count else {
            return nil
        }
        return articleDataSource[row]
    }

    func titleForHeader(withSearchOn searchOn: Bool) -> String? {
        return searchOn ? nil : "Bookmarked articles"
    }

    func getArticlesFor(_ searchTerm: String) {
        WikiDataProvider.getArticlesFor(searchTerm: searchTerm, completionSuccess: {[weak self] (articles) in
            self?.update(with: articles)
        }) {[weak self] (error) in
            print(error.localizedDescription)
            self?.articleListView?.showError(error.localizedDescription)
        }
    }

    @objc func getSavedArticles() {
        let viewContext = CoreDataManager.shared.viewContext
        self.savedArticlesDataSource = WikiArticle.fetchAll(in: viewContext).map({ (article) -> WikiPage in
            let thumbnail = WikiThumbnail(source: article.imageURL, width: 50, height: 50)
            let page = WikiPage(pageid: nil, ns: nil, title: article.title, index: nil, thumbnail: thumbnail, description: article.subtitle)
            return page
        })
    }

    func update(with articles: [WikiPage]) {
        self.articleDataSource = articles
    }

    func resetDataSource() {
        self.articleDataSource.removeAll()
        self.articleListView?.reloadView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
