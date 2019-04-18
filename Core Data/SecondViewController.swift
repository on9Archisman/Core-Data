//
//  SecondViewController.swift
//  Core Data
//
//  Created by Archisman Banerjee on 18/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//

import UIKit
import CoreData

protocol SecondVCDelegate
{
    func selectedCourse(course: Course)
}

class SecondViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var txtCourseNumber: UITextField!
    @IBOutlet weak var txtCourseName: UITextField!
    @IBOutlet weak var tableViewCourse: UITableView!
    
    let tblCourseName = String(describing: Course.self)
    
    var searchResultCourse = [Course]()
    
    // Custom Delegate
    var customDelegate: SecondVCDelegate?
    
    // MARK: VC Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
        
        let fetchRequestCourse: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            searchResultCourse = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestCourse)
            tableViewCourse.reloadData()
        }
        catch
        {
            alert(message: error.localizedDescription)
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResultCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "REUSE")
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "REUSE")
        }
        
        let managedObjectCourse = searchResultCourse[indexPath.row]
        
        cell?.textLabel?.text = "\(managedObjectCourse.courseId) || \(managedObjectCourse.couseName!)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("didSelectRowAt indexPath =", indexPath.row)
        
        let managedObjectCourse = searchResultCourse[indexPath.row]
        customDelegate?.selectedCourse(course: managedObjectCourse)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let managedObjectCourse = searchResultCourse[indexPath.row]
            
            DatabaseController.persistentContainer.viewContext.delete(managedObjectCourse)
            
            DatabaseController.saveContext { (flag) in
                
                if flag
                {
                    print("Data deleted from DB")
                    
                    searchResultCourse.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                else
                {
                    print("Data not deleted from DB")
                }
            }
        }
    }
    
    // MARK: IBAction
    @IBAction func actionSave(_ sender: Any)
    {
        view.endEditing(true)
        
        if (txtCourseNumber.text!.count == 0 || txtCourseName.text!.count == 0)
        {
            alert(message: "Please fill all the fields !!")
        }
        else
        {
            let managedObjectCourse: Course = NSEntityDescription.insertNewObject(forEntityName: tblCourseName, into: DatabaseController.persistentContainer.viewContext) as! Course
            
            managedObjectCourse.couseName = txtCourseName.text
            
            let number: Int32 = Int32(txtCourseNumber.text!)!
            managedObjectCourse.courseId = number
            
            DatabaseController.saveContext { (flag) in
                
                if flag
                {
                    txtCourseNumber.text = ""
                    txtCourseName.text = ""
                    
                    viewWillAppear(true)
                }
            }
        }
    }
    
    // MARK: IBAction
    @IBAction func actionClose(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Miscellneous
    func alert(message: String)
    {
        let alert = UIAlertController(title: Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, message: message,  preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
