//
//  SettingsViewController.swift
//  PasswordStorage
//
//  Created by user195362 on 4/19/21.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var usernameSwitch: UISwitch!
    @IBAction func showUsername(_ sender: UISwitch) {
        UserDefaults.standard.setValue(usernameSwitch.isOn, forKey: "showUsername")
    }
    @IBAction func changeTapped(_ sender: UIButton) {
        if (isKeyPresentInUserDefaults(key: "passcode")) {
            let alert = UIAlertController(title: "Change Passcode", message: "Please enter your old passcode and a new passcode", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Old Passcode"
            })
            
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "New Passcode"
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField1 = alert?.textFields![0]
                let textField2 = alert?.textFields![1]
                let passcode = textField1?.text
                if (passcode == UserDefaults.standard.value(forKey: "passcode") as? String) {
                    UserDefaults.standard.setValue(textField2?.text, forKey: "passcode")
                    let alert = UIAlertController(title: "Passcode Successfully Changed", message: "Press OK to continue", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Wrong Passcode", message: "Please try again", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 44
        
        usernameSwitch.isOn = UserDefaults.standard.bool(forKey: "showUsername")
    }

    // MARK: - Table view data source
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
