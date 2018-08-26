//
//  UITableView+Extensions.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    static var nibName: String { get }
    static func nib() -> UINib
}

extension NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

protocol ReusableView: class {
    static var ReuseIdentifier: String { get }
}

extension ReusableView {
    static var ReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    func registerNibOfType<T>(_ type: T.Type) where T: UITableViewCell & NibLoadable {
        self.register(T.nib(), forCellReuseIdentifier: T.ReuseIdentifier)
    }

    func dequeueCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: T.ReuseIdentifier, for: indexPath) as! T
    }
}
