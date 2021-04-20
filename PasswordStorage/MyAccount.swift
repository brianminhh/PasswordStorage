//
//  Account.swift
//  PasswordStorage
//
//  Created by user195362 on 4/18/21.
//

import Foundation

class MyAccount {
    var website: String
    var username: String
    var password: String
    var date: String
    
    init (website: String, username: String, password: String, date: String) {
        self.website = website
        self.username = username
        self.password = password
        self.date = date
    }
}
