//
//  ArticleListTableViewCell.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleListTableViewCell: UITableViewCell, NibLoadable {

    @IBOutlet private(set) weak var articleImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    func setup(with article: WikiPage) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
        let imageURL = URL(string: article.thumbnail?.source ?? "")
        self.articleImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "article_placeholder"))
    }

}
