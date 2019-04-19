//
//  ViewController.swift
//  Core Data
//
//  Created by Archisman Banerjee on 17/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SecondViewControllerDelegate
{
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var btnCourse: UIButton!
    @IBOutlet weak var tableViewStudent: UITableView!
    
    let tblStudentName = String(describing: Student.self)
    
    let datePicker = UIDatePicker()
    
    var searchResultStudent = [Student]()
    
    var updateFlag: Bool = false
    var index: Int?
    
    var managedObjectCourse: Course?
    
    // MARK: VC Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // flexible space
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonPressed))
        let save = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(saveButtonPressed))
        toolbar.setItems([cancel,flexibleSpace,save], animated: false)
        txtDOB.inputAccessoryView = toolbar
        
        // MARK: Date Picker
        datePicker.datePickerMode = .date
        txtDOB.inputView = datePicker
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
        
        let fetchRequestStudent: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            searchResultStudent = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestStudent)
            tableViewStudent.reloadData()
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
        return searchResultStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "REUSE")
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "REUSE")
        }
        
        let managedObjectStudent = searchResultStudent[indexPath.row]
        
        var temp = "\(managedObjectStudent.firstName!) \(managedObjectStudent.lastName!) || "
        
        let now = Date()
        let dob: Date = managedObjectStudent.dob! as Date
        let calendar = Calendar.current.dateComponents([.year], from: dob, to: now)
        let age = calendar.year!
        
        temp += "\(age) || \(String(describing: managedObjectStudent.mobile))"
        
        cell?.textLabel?.text = temp
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("didSelectRowAt indexPath =", indexPath.row)
        
        let fetchRequestStudent: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            searchResultStudent = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestStudent)
            
            let managedObjectStudent = searchResultStudent[indexPath.row]
            
            txtFirstName.text = managedObjectStudent.firstName
            txtLastName.text = managedObjectStudent.lastName
            txtMobile.text = String(managedObjectStudent.mobile)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
            txtDOB.text = formatter.string(from: managedObjectStudent.dob! as Date)
            
            updateFlag = true
            index = indexPath.row
        }
        catch
        {
            alert(message: error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let managedObjectStudent = searchResultStudent[indexPath.row]
            
            DatabaseController.persistentContainer.viewContext.delete(managedObjectStudent)
            
            DatabaseController.saveContext { (flag) in
                
                if flag
                {
                    print("Data deleted from DB")
                    
                    searchResultStudent.remove(at: indexPath.row)
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
        
        if (txtFirstName.text!.count == 0 || txtLastName.text!.count == 0 || txtDOB.text!.count == 0 || txtMobile.text!.count == 0)
        {
            alert(message: "Please fill all the fields !!")
        }
        else if (updateFlag)
        {
            let managedObjectStudent = searchResultStudent[index!]
            
            managedObjectStudent.firstName = txtFirstName.text
            managedObjectStudent.lastName = txtLastName.text
            
            let number: Int64 = Int64(txtMobile.text!)!
            managedObjectStudent.mobile = number
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
            let date = formatter.date(from: txtDOB.text!)
            managedObjectStudent.dob = date as NSDate?
            
            if (managedObjectCourse != nil)
            {
                managedObjectStudent.addToRelationshipWithCourse(managedObjectCourse!)
            }
            
            DatabaseController.saveContext { (flag) in
                
                if flag
                {
                    txtFirstName.text = ""
                    txtLastName.text = ""
                    txtDOB.text = ""
                    txtMobile.text = ""
                    
                    updateFlag = false
                    
                    btnCourse.setTitle("Select Course", for: .normal)
                    
                    viewWillAppear(true)
                }
            }
        }
        else
        {
            let managedObjectStudent: Student = NSEntityDescription.insertNewObject(forEntityName: tblStudentName, into: DatabaseController.persistentContainer.viewContext) as! Student
            
            managedObjectStudent.firstName = txtFirstName.text
            managedObjectStudent.lastName = txtLastName.text
            
            let number: Int64 = Int64(txtMobile.text!)!
            managedObjectStudent.mobile = number
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
            let date = formatter.date(from: txtDOB.text!)
            managedObjectStudent.dob = date as NSDate?
            
            if (managedObjectCourse != nil)
            {
                managedObjectStudent.addToRelationshipWithCourse(managedObjectCourse!)
            }
            
            DatabaseController.saveContext { (flag) in
                
                if flag
                {
                    txtFirstName.text = ""
                    txtLastName.text = ""
                    txtDOB.text = ""
                    txtMobile.text = ""
                    
                    btnCourse.setTitle("Select Course", for: .normal)
                    
                    viewWillAppear(true)
                }
            }
        }
    }
    
    // MARK: Miscellneous
    func alert(message: String)
    {
        let alert = UIAlertController(title: Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, message: message,  preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed()
    {
        // Format Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: datePicker.date)
        txtDOB.text = "\(dateString)"
        txtDOB.resignFirstResponder()
    }
    
    @objc func cancelButtonPressed()
    {
        txtDOB.text = ""
        txtDOB.resignFirstResponder()
    }
    
    // MARK: Custom Delegate
    func SelectCourse(course: Course?)
    {
        if let course = course
        {
            print(course)
            
            btnCourse.setTitle("Selected Course ~ \(course.courseId)", for: .normal)
            
            managedObjectCourse = course
        }
        else
        {
            managedObjectCourse = nil
        }
        
    }
    
    /*
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
        
        /* Course */
        
        let managedObjectCourse: Course = NSEntityDescription.insertNewObject(forEntityName: tblCourseName, into: DatabaseController.persistentContainer.viewContext) as! Course
        
        managedObjectCourse.courseId = 201
        managedObjectCourse.couseName = "Computer Science"
        
        managedObjectStudent.addToRelationshipWithCourse(managedObjectCourse)
        // managedObjectCourse.addToRelationshipWithStudent(managedObjectStudent)
        
        DatabaseController.saveContext { (flag) in
            
            print("OKAY")
        }
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
                
                temp += ", I'm \(age) years old & my contact number is \(String(describing: managedObjectStudent.mobile))"
                
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
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Segue"
        {
            if let nextViewController = segue.destination as? SecondViewController
            {
                nextViewController.SecondViewControllerDelegate = self
            }
        }
    }
}
