//
//  LoginViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/8/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit

 
public let defaults = UserDefaults(suiteName: "group.mizin.Avalon-print")!

 extension UITextField {
     @IBInspectable var placeHolderColor: UIColor? {
         get {
             return self.placeHolderColor
         }
         set {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
         }
     }
 }


class LoginViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    let incorrectLogin = UIAlertController(title: "Ошибка входа", message: "Неправильный логин или пароль", preferredStyle: UIAlertControllerStyle.alert )
    let noInternet = UIAlertController(title: "Ошибка входа", message: "Нету подключения к интернету", preferredStyle: UIAlertControllerStyle.alert )
    
    @IBOutlet weak var LogInButton: ButtonMockup!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainView: UIView!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            defaults.synchronize()
        
            loginTextField.delegate = self
            passwordTextField.delegate = self
        
            incorrectLogin.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.activityIndicator.stopAnimating()
           UIApplication.shared.endIgnoringInteractionEvents()
        }))
    }
    
    
    @IBAction func closeLoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

 
    @IBAction func onLogInButtonClicked(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
     
        var request = URLRequest(url: URL(string: "http://mizin-dev.com/login_api.php")!)
        request.httpMethod = "POST"
        let postString = "email=\(loginTextField.text!)&password=\(passwordTextField.text!)"
        request.httpBody = postString.data(using: .utf8)
        
        let task1 = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("ERROR")
                //internet.enabled = false
                 UIApplication.shared.endIgnoringInteractionEvents()
                self.present(self.noInternet, animated: true, completion: nil)
               
                
            } else {
                if let content = data {
                    do {
                        
                        let user = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let phpAnswer = user["result"] as! String
                        let successfull = "OK"
                        if (phpAnswer == successfull) {
                              UIApplication.shared.endIgnoringInteractionEvents()
                            
                            //MARK: HERE WILL BE SAVING USER EMAIL AND PASS TO 
                            //USERDEFAULTS FOR KEPPING LOGGED IN
                            
                            defaults.set(self.loginTextField.text!, forKey: "login")
                            defaults.set(self.passwordTextField.text!, forKey: "password")
                            defaults.set(true, forKey: "loggedIn")
                            defaults.synchronize()
                            
                            
                            print("\n\nSuccessfully logged in   ", "  result",  user["result"] as Any, "\n\n")
                           
                            
                            if let phpUserReturnedData = user["user"] as? NSDictionary {
                                
                               
                                print("\nPHP RESPOND ABOUT USER DATA\nUser: ",  phpUserReturnedData["name"] as! String)
                                print("E-mail: ",  phpUserReturnedData["email"] as! String)
                                print("Password: ",  phpUserReturnedData["password"] as! String)
                                print("Cell Number: ",  phpUserReturnedData["phone_number"] as! String)
                                
                                 defaults.set((phpUserReturnedData["name"]  as! String), forKey: "nameSurnameToProfile")
                                 defaults.set((phpUserReturnedData["email"]  as! String), forKey: "emailToProfile")
                                 defaults.set((phpUserReturnedData["phone_number"]  as! String), forKey: "cellNumberToProfile")
                                defaults.synchronize()
                                
                                 print("\nUSER PROFILE DATA \n",  (phpUserReturnedData["name"]  as! String), "\n", (phpUserReturnedData["email"]  as! String), "\n" , (phpUserReturnedData["phone_number"]  as! String))
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                             print("Login or password are incorrect", "result", user["result"] as Any)
                             UIApplication.shared.endIgnoringInteractionEvents()
                             self.present(self.incorrectLogin, animated: true, completion: nil)
                        }
                    }
               
                    catch {}
   
                }//if let content
            }
        }//task1
        task1.resume()

    }
    
    
    @IBAction func emailFieldValidation(_ sender: Any) { validation() }
    @IBAction func passwordFieldValidation(_ sender: Any) { validation() }
    
    func validation () {
        let characterSet = NSCharacterSet(charactersIn: "@")
        let badCharacterSet = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
        
        if (loginTextField.text?.characters.count)! < 5 || loginTextField.text?.rangeOfCharacter(from: characterSet as CharacterSet, options: .caseInsensitive ) == nil || loginTextField.text?.rangeOfCharacter(from: badCharacterSet as CharacterSet, options: .caseInsensitive ) != nil || (passwordTextField.text?.characters.count)! < 6 {
            LogInButton.isEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.LogInButton.alpha = 0.6})
           
            
        } else {
            LogInButton.isEnabled = true;
            
            UIView.animate(withDuration: 0.5, animations: {
                self.LogInButton.alpha = 1.0 })
            }
    }
    
    
   
    
    func closeKeyboard() {
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

