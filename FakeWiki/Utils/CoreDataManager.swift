//
//  CoreDataManager.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 26/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSPersistentContainer {
    static let shared = CoreDataManager()

    private init() {
        let objectModelURL = Bundle.main.url(forResource: "FakeWiki", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOf: objectModelURL!)
        super.init(name: "FakeWiki", managedObjectModel: managedObjectModel!)
        self.loadPersistentStores { (_, _) in}
    }
}
