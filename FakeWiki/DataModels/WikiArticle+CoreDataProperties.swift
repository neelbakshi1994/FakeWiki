//
//  WikiArticle+CoreDataProperties.swift
//  
//
//  Created by Neel Bakshi on 26/08/18.
//
//

import Foundation
import CoreData


extension WikiArticle {

    public class func fetchRequest() -> NSFetchRequest<WikiArticle> {
        return NSFetchRequest<WikiArticle>(entityName: "WikiArticle")
    }


    static func fetchAll(in context: NSManagedObjectContext) -> [WikiArticle] {
        do {
            let savedArticles: [WikiArticle] = try context.fetch(WikiArticle.fetchRequest())
            return savedArticles
        } catch {
            return []
        }
    }

    static func articleExistsWithTitle(_ title: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<WikiArticle> = WikiArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF.title == %@", title)
        do {
            let articles = try context.fetch(fetchRequest)
            return articles.count > 0
        } catch {
            return false
        }
    }

}
