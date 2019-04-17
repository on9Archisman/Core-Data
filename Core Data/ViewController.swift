//
//  ViewController.swift
//  Core Data
//
//  Created by Archisman Banerjee on 17/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController
{
    let tblStudentName = String(describing: Student.self)
    let tblCourseName = String(describing: Course.self)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: Insert
        InsertData()
        
        // MARK: Fetch
        FetchData()
    }
    
    func InsertData()
    {
        /* Student */
        
        /*
        let entityDescriptionStudent = NSEntityDescription.entity(forEntityName: tblStudentName, in: DatabaseController.persistentContainer.viewContext)
        
        let managedObjectStudent: Student = NSManagedObject.init(entity: entityDescriptionStudent!, insertInto: DatabaseController.persistentContainer.viewContext) as! Student
        */
        
        let managedObjectStudent: Student = NSEntityDescription.insertNewObject(forEntityName: tblStudentName, into: DatabaseController.persistentContainer.viewContext) as! Student
        
        managedObjectStudent.firstName = "Archisman"
        managedObjectStudent.lastName = "Banerjee"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        let date = formatter.date(from: "18/12/1991")
        managedObjectStudent.dob = date as NSDate?
        
        managedObjectStudent.mobile = 8981833530
        
        DatabaseController.saveContext()
    }
    
    func FetchData()
    {
        /* Student */
        
        // let fetchRequestStudent = NSFetchRequest<NSFetchRequestResult>.init(entityName: tblStudentName)
        
        let fetchRequestStudent: NSFetchRequest<Student> = Student.fetchRequest()
        
        do
        {
            let searchResult: [Student] = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestStudent)
            
            print("No of rows =", searchResult.count)
            
            for managedObjectStudent in searchResult
            {
                var temp = "My name is \(managedObjectStudent.firstName!) \(managedObjectStudent.lastName!)"
                
                let now = Date()
                let dob: Date = managedObjectStudent.dob! as Date
                let calendar = Calendar.current.dateComponents([.year], from: dob, to: now)
                let age = calendar.year!
                
                temp += ", I'm \(age) years old & my contact number is \(managedObjectStudent.mobile)"
                
                print(temp)
                
                // DatabaseController.persistentContainer.viewContext.delete(managedObjectStudent)
                // DatabaseController.saveContext()
            }
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        
    }
}
