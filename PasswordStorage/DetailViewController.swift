//
//  DetailViewController.swift
//  PasswordStorage
//
//  Created by user195362 on 4/19/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    var account: MyAccount!

    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Home", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        websiteLabel.text = account.website
        usernameLabel.text = "Username: " + account.username
        passwordLabel.text = "Password: " + account.password
        dateLabel.text = "Date Added: " + account.date
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(sender:)))
        passwordLabel.isUserInteractionEnabled = true
        passwordLabel.addGestureRecognizer(longGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc
    func longTap(sender: UILongPressGestureRecognizer) {
        UIPasteboard.general.string = account.password
    }
    
    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditView" {
            let vc = segue.destination as! EditViewController
            vc.account = account
        }
    }
    
    @IBAction func unwindFromEditPassword(sender: UIStoryboardSegue) {
        let addPassVC = sender.source as! EditViewController
        if let str = addPassVC.account {
            account = MyAccount(website: str.website, username: str.username, password: str.password, date: dateLabel.text!)
            websiteLabel.text = account.website
            usernameLabel.text = "Username: " + account.username
            passwordLabel.text = "Password: " + account.password
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
