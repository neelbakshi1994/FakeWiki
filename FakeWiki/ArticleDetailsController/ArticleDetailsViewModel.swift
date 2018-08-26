//
//  ArticleDetailsViewModel.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 26/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import Foundation

class ArticleDetailsViewModel {

    private weak var articlesDetailView: ArticleDetailsViewProtocol?
    private(set) var article: WikiPage!

    required init(with view: ArticleDetailsViewProtocol, andArticle article: WikiPage) {
        self.articlesDetailView = view
        self.article = article
    }

    func requestToLoad() -> URLRequest? {
        let urlToLoad = WikiDetailEndpoint + self.article.title!.replacingOccurrences(of: " ", with: "_")
        guard let url = URL(string: urlToLoad) else {
            return nil
        }
        return URLRequest(url: url)
    }

    func shouldShowBookmarkButton() -> Bool {
        let viewContext = CoreDataManager.shared.viewContext
        guard let title = article.title, !WikiArticle.articleExistsWithTitle(title, in: viewContext) else { return false }
        return true
    }

    func saveArticle() {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        let articleToBeSaved = WikiArticle.new(in: backgroundContext)
        articleToBeSaved.title = article.title
        articleToBeSaved.subtitle = article.description
        articleToBeSaved.imageURL = article.thumbnail?.source
        do {
            try backgroundContext.save()
            NSLog("Saved")
            NotificationCenter.default.post(name: ArticleSaveNotification, object: nil)
        } catch {
            NSLog("Could not save article")
        }
    }
}
