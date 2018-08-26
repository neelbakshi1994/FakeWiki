//
//  WikiArticle+CoreDataClass.swift
//  
//
//  Created by Neel Bakshi on 26/08/18.
//
//

import Foundation
import CoreData

@objc(WikiArticle)
public class WikiArticle: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var subtitle: String?
    @NSManaged var imageURL: String?

    static func new(in context: NSManagedObjectContext) -> WikiArticle {
        let entityDescription = NSEntityDescription.entity(forEntityName: "WikiArticle", in: context)
        return WikiArticle(entity: entityDescription!, insertInto: context)
    }
}
