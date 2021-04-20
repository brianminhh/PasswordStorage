//
//  ViewController.swift
//  PasswordStorage
//
//  Created by user195362 on 4/18/21.
//

import UIKit
import CryptoKit

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var password: String!
    var account: MyAccount?
    
    @IBOutlet weak var websiteInput: UITextField?
    @IBOutlet weak var usernameInput: UITextField?
    @IBOutlet weak var passwordInput: UITextField?
    @IBOutlet weak var encodingInput: UITextField!
    @IBOutlet weak var lengthSlider: UISlider!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        websiteInput?.delegate = self
        usernameInput?.delegate = self
        passwordInput?.delegate = self
        
        websiteInput?.text = account?.website
        usernameInput?.text = account?.username
        passwordInput?.text = account?.password
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Website, username, or password is empty", message: "Please make sure all required inputs are filled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if (websiteInput?.text == "" || usernameInput?.text == "" || passwordInput?.text == "") {
            self.present(alert, animated: true)
        } else {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            let finalDate = dateFormatter.string(from: date)
                        
            account = MyAccount(website: websiteInput!.text!, username: usernameInput!.text!, password: passwordInput!.text!, date: finalDate)
            performSegue(withIdentifier: "unwindFromEditPassword", sender: self)
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        lengthLabel.text = String(Int(lengthSlider.value))
        
        guard let length = Int(lengthLabel.text!) else { return }
        if (password != nil) {
            let index = password.index(password.startIndex, offsetBy: length)
            let pass = password[..<index]
            
            passwordInput?.text = String(pass)
        }
    }
    @IBAction func inputChanged(_ sender: Any) {
        guard let length = Int(lengthLabel.text!) else { return }
        password = randomStringWithLength(len: 30)
        let index = password.index(password.startIndex, offsetBy: length)
        let pass = password[..<index]
        
        passwordInput?.text = String(pass)
    }
    
    func randomStringWithLength (len : Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"

        let randomString : NSMutableString = NSMutableString(capacity: len)

        for _ in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }

        return String(randomString)
    }
}

