//
//  ViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-01.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var buttonBrowse: UIButton!
    var offline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UITextField.appearance().tintColor = .orange;
        
        // Dismiss the textfield when the view is tapped.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleViewTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // Define the action when the email input lose focus.
        emailText.delegate = self
        emailText.addTarget(self, action: #selector(self.setPasswordForUser(_:)), for: UIControlEvents.editingDidEnd)
        
        // Check if the user has login before
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey == true {
            let username = UserDefaults.standard.string(forKey: "username")
            if let account = username {
                do {
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
                    emailText.text = passwordItem.account
                    passwordText.text = try passwordItem.readPassword()
                }
                catch {
                    debugPrint("Error reading password from keychain - \(error)")
                }
            }
        }
        
        // Set the browse offline button according to if the use has downloaded data.
        if hasOfflineData() == false {
            buttonBrowse.isEnabled = false
            buttonBrowse.backgroundColor = UIColor.lightGray
        } else {
            buttonBrowse.isEnabled = true
            buttonBrowse.backgroundColor = UIColor(hex: StpColor.Orange)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailText.setBottomBorder(color: StpColor.Orange)
        passwordText.setBottomBorder(color: StpColor.Orange)
    }
    
    
    // MARK: dismiss the keyboard when user click the view other than the text input box.
    func handleViewTap(_ sender: UITapGestureRecognizer){
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
    
    
    // Get password from keychain for the user.
    func setPasswordForUser(_ sender: UITapGestureRecognizer){
        if let account = emailText.text {
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
                passwordText.text = try passwordItem.readPassword()
            }
            catch {
                debugPrint("cannot get password for user: \(account)")
                debugPrint("Error reading password from keychain - \(error)")
                passwordText.text = ""
            }
        } else {
            passwordText.text = ""
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = Constants.TITLE
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: save username and password to keychain for next login
    func saveLogin(username: String, password: String){
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        UserDefaults.standard.set(username, forKey: "username")
        
        let today = Date()
        UserDefaults.standard.set(today, forKey: "loginDate")
        
        savePassword(username: username, password: password)
    }
    
    
    func savePassword(username: String, password: String) {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(password)
        }
        catch {
            debugPrint("Error updating keychain - \(error)")
        }
    }
    
    
    func deleteLogin(username: String?) {
        UserDefaults.standard.set(false, forKey: "hasLoginKey")
        if let user = username {
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user, accessGroup: KeychainConfiguration.accessGroup)
                try passwordItem.deleteItem()
            }
            catch {
                fatalError("Error deleting keychain - \(error)")
            }
        }
        
    }
    
    func loginSuccess(userId: Int?, error: String?){
        guard let userId = userId else {
            OperationQueue.main.addOperation {
                if let error = error {
                        self.showAlert(msg: error.description)
                } else {
                        self.showAlert(msg: "Cannot login, please try later.")
                }
            }
            return
        }
        StpVariables.userID = userId
        
        // Save login information to keychain for next login.
        saveLogin(username: emailText.text!, password: passwordText.text!)
        
        // Set offline to false
        offline = false
        
        // navigate to other controller to display the publication list.
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "segueDisplayPubList", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDisplayPubList" {
            if let destinationVC = segue.destination as? PubListViewController {
                destinationVC.offline = offline
            }
        }
    }
    
    
    func showAlert(msg: String){
        let alertController = UIAlertController(title:"STP in Pocket", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
            print("OK")
            
        }
        alertController.addAction(remindAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // call web API to login
    func checkLogin(email: String, password: String){
        
        // prepare json data
        let json = ["email": email, "password": password]
        
        // create post request
        let loginEndpoint: String = Constants.URL_END_POINT + "users"
        guard let localIIS = URL(string: loginEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: localIIS)
        request.httpMethod = "POST"
        
        //debugPrint(request.url?.absoluteString)
        
        // insert json data to request
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if !JSONSerialization.isValidJSONObject(json){
            print("invalid input")
            print(json)
            return
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            
            guard  error == nil else{
                print("error=\(error)")
                self.loginSuccess(userId: nil, error: error?.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                print("404")
                self.loginSuccess(userId: nil, error: "Bad username/password.")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("error is \(error), \(response.debugDescription)")
                self.loginSuccess(userId: nil, error: error.debugDescription)
                return
            }
            // parse the result as JSON
            guard let todo = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] else{
                return
            }
            
            for object in todo!{
                if let unwrapped = object["userid"] {
                    //print("unwrapped = \(unwrapped)")
                    self.loginSuccess(userId: unwrapped as? Int , error: "")
                }
            }
        }
        task.resume()
    }
    
    
    func hasOfflineData() -> Bool {
        // Check if the user has login before
        if let lastLoginDate = UserDefaults.standard.object(forKey: "loginDate") as? Date {
            let expiredDate = lastLoginDate.addingTimeInterval( 24.0 * 60.0 * 60.0 * Constants.SESSION)
            let today = Date()
            if today > expiredDate {
                return false
            }
        } else { // no login history
            return false
        }
        
        // Check if there is any offline data.
        let publications = StpDB.instance.getPublications()
        
        if publications.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: Actions
    // User taps 'browse offline'.
    @IBAction func browseOffline(_ sender: UIButton) {
        offline = true  // will be sent to next controller for instructing offline behaviours.
        
        // Check if the user has login before
        if let lastLoginDate = UserDefaults.standard.object(forKey: "loginDate") as? Date {
            let expiredDate = lastLoginDate.addingTimeInterval( 24.0 * 60.0 * 60.0 * Constants.SESSION)
            let today = Date()
            if today > expiredDate {
                showAlert(msg: "The \(Constants.SESSION) days' limitation for offline browsing is expired. Please login again.")
            }
        } else { // no login history
            showAlert(msg: "Sorry. You don't have the authorization to access the offline data.")
        }

        // Check if there is any offline data.
        let publications = StpDB.instance.getPublications()
        
        if publications.count == 0 {
            showAlert(msg: "No publication is available for browsing offline. Please download some first.")
        } else {
            DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "segueDisplayPubList", sender: self)
            }

        }
    }

    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let email = emailText.text, !email.isEmpty else{
            let alertController = UIAlertController(title:"STP in Pocket", message: "Please enter your email address", preferredStyle: UIAlertControllerStyle.alert)
            let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
                print("OK")
            }
            alertController.addAction(remindAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let pwd = passwordText.text, !pwd.isEmpty else {
            let alertController = UIAlertController(title:"STP in Pocket", message: "Please enter your password", preferredStyle: UIAlertControllerStyle.alert)
            let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
                print("OK")
                
            }
            alertController.addAction(remindAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        checkLogin(email: email, password: pwd)
    }
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        if offline == false {
            debugPrint("sign out, delete key chain.")
            deleteLogin(username: emailText.text)
            emailText.text = ""
            passwordText.text = ""
        }
        // Set the browse offline button according to if the use has downloaded data.
        if hasOfflineData() == false {
            
            buttonBrowse.isEnabled = false
            buttonBrowse.backgroundColor = UIColor.lightGray
            
        } else {
            buttonBrowse.isEnabled = true
            buttonBrowse.backgroundColor = UIColor(hex: "ed9022")
        }
    }
}

