//
//  ViewController.swift
//  Log In Demo
//
//  Created by arjun gupta on 05/03/17.
//  Copyright © 2017 arjun gupta. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    var isLoggedIn = false
    
    
    
    @IBAction func Logout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    context.delete(result)
                    do{
                        try context.save()
                        
                    }
                    catch{
                        print("Individual delete failed")
                    }
                }
                
                label.alpha = 0
                logoutButton.alpha = 0
                //textField.alpha = 1
                //loginButton.alpha=1
                loginButton.setTitle("Login", for: [])
                isLoggedIn = false
            }
        }
        catch{
            print("delete failed")
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoggedIn{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            do{
                let results = try context.fetch(request)
                
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                            result.setValue(textField.text, forKey: "name")
                        do{
                            try context.save()
                        }
                        catch{
                            print("update username failed")
                        }
                        
                    }
                    label.text = "Hi there " + textField.text! + "!"
                    
                }
                
            }
            catch{
                print("update username failed")
                
            }
        }
            
        else{
        
            let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newValue.setValue(textField.text, forKey: "name")
            do {
                try context.save()
                //textField.alpha = 0
                //lo    ginButton.alpha = 0
                
                loginButton.setTitle("Update username", for: [])
            
                label.alpha = 1
                label.text = "Hi there " + textField.text! + "!"
                logoutButton.alpha = 1
            
                isLoggedIn = true
            
            
            }
            catch{
                print("failed to save")
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            
            for result in results as! [NSManagedObject]{
                if let username = result.value(forKey: "name") as? String{
                    
                    //textField.alpha = 0
                    //loginButton.alpha = 0
                    
                    loginButton.setTitle("Update username", for: [])
                    logoutButton.alpha = 1

                    label.alpha = 1
                    label.text = "Hi there " + username + "!"
                    
                    
                }
            }
        }
        catch{
            print("Request failed")
        }
    }

    @IBOutlet weak var loginButton: UIButton!
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

