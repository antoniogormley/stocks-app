//
//  Persistence.swift
//  Stocks App
//
//  Created by Antonio Gormley on 16/08/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container:NSPersistentContainer
    
    init(inMemory:Bool = false) {
        container = NSPersistentContainer(name: "StockApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error ) in
            if let error = error as NSError? {
                fatalError("Unresolved error\(error), \(error.userInfo)")
            }
        }
    }
    
}


