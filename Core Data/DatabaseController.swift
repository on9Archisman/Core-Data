//
//  DatabaseController.swift
//  Core Data
//
//  Created by Archisman Banerjee on 17/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//

import Foundation
import CoreData

final class DatabaseController
{
    private init() {}
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Core_Data")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext (completionHandler: (Bool) -> ())
    {
        let context = DatabaseController.persistentContainer.viewContext
        
        if context.hasChanges
        {
            do
            {
                try context.save()
                
                print("Data Saved")
                
                completionHandler(true)
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        else
        {
            completionHandler(false)
        }
    }
}
