//
//  TableViewController.swift
//  PasswordStorage
//
//  Created by user195362 on 4/18/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var accounts: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var curAccount: MyAccount!
    var indexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: ["showUsername": true])

        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        accounts = getAccount()
        tableView.reloadData()
        
        if (!isKeyPresentInUserDefaults(key: "passcode")) {
            let alert = UIAlertController(title: "Passcode not found", message: "Please enter a new passcode", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Passcode"
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField1 = alert?.textFields![0]
                UserDefaults.standard.setValue(textField1?.text, forKey: "passcode")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accounts.count
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getAccount()-> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        var account: [NSManagedObject] = []
        do {
            account = try self.managedObjectContext
                .fetch(fetchRequest)
        } catch {
            print("getAccount error: \(error)")
        }
        
        return account
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.value(forKey: "website") as? String
        if (UserDefaults.standard.bool(forKey: "showUsername")) {
            cell.detailTextLabel?.text = account.value(forKey: "username") as? String
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func removeAccount(_ account: NSManagedObject) {
        managedObjectContext.delete(account)
        appDelegate.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let account = accounts[indexPath.row]
            accounts.remove(at: indexPath.row)
            removeAccount(account)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accounts = getAccount()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var passcode: String!
        if (isKeyPresentInUserDefaults(key: "passcode")) {
            let alert = UIAlertController(title: "Passcode Required", message: "Please enter your passcode", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Passcode"
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField1 = alert?.textFields![0]
                passcode = textField1?.text
                if (passcode == UserDefaults.standard.value(forKey: "passcode") as? String) {
                    self.curAccount = MyAccount(website: self.accounts[indexPath.row].value(forKey: "website") as! String, username: self.accounts[indexPath.row].value(forKey: "username") as! String, password: self.accounts[indexPath.row].value(forKey: "password") as! String, date: self.accounts[indexPath.row].value(forKey: "date") as! String)
                    self.indexPath = indexPath
                    
                    self.performSegue(withIdentifier: "toDetailView", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Wrong Passcode", message: "Please try again", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let vc = segue.destination as! DetailViewController
            vc.account = curAccount
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath)-> Bool {
        return true
    }
    
    func insertAccount(username: String, website: String, password: String, date: String) {
        let account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: self.managedObjectContext)
        account.setValue(username, forKey: "username")
        account.setValue(website, forKey: "website")
        account.setValue(password, forKey: "password")
        account.setValue(date, forKey: "date")
        appDelegate.saveContext()
    }
    
    @IBAction func unwindFromAddPassword(sender: UIStoryboardSegue) {
        let addPassVC = sender.source as! ViewController
        if let str = addPassVC.account {
            insertAccount(username: str.username, website: str.website, password: str.password, date: str.date)
            accounts = getAccount()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func undwindFromDetail(sender: UIStoryboardSegue) {
        let editPassVC = sender.source as! DetailViewController
        if let str = editPassVC.account {
            accounts[indexPath.row].setValue(str.username, forKey: "username")
            accounts[indexPath.row].setValue(str.password, forKey: "password")
            accounts[indexPath.row].setValue(str.website, forKey: "website")
            accounts = getAccount()
            self.tableView.reloadData()
        }
    }

}
