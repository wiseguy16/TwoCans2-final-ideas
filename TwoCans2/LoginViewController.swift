//
//  LoginViewController.swift
//  TwoCans2
//
//  Created by Gregory Weiss on 9/16/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sessionIDtextfield: UITextField!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
   
    
 //   var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) // Runs after the view is visible to user  PUT ANIMATION HERE!!!
    {
        super.viewDidAppear(animated)
        if let user = FIRAuth.auth()?.currentUser
        {
            userIsSignedIn(user)
            
        }
    }
    
    // MARK: - Firebase methods
    
    func userIsSignedIn(user: FIRUser)
    {
        AppState.sharedInstance.displayName = user.displayName ?? user.email
        AppState.sharedInstance.signedIn = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    // MARK: - Action handlers
    
    
    @IBAction func signIn(sender: UIBarButtonItem)
    {
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
                user, error in
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                print("Sign In successfull")
                self.userIsSignedIn(user!)
            })
        }
        
    }
    
    
    @IBAction func registeruser(sender: UIBarButtonItem)
    {
        let firebaseAuth = FIRAuth.auth()
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            firebaseAuth?.createUserWithEmail(email, password: password) {
                user, error in
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                print("USER created successfully")
                self.setDisplayName(user!)
            }
        }
        
    }
    
    func setDisplayName(user: FIRUser)
    {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
        changeRequest.commitChangesWithCompletion() {
            error in
            
            if let error = error
            {
                print(error.localizedDescription)
                return
            }
            let currentUser = (FIRAuth.auth()?.currentUser!)!
            self.userIsSignedIn(currentUser)
            
        }
        
        
    }
    
    // TextField delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == emailTextField && emailTextField.text?.characters.count>0
        {
            emailTextField.resignFirstResponder()
            if passwordTextField.text?.characters.count == 0
            {
                passwordTextField.becomeFirstResponder()
            }
        }
        else if textField == passwordTextField && passwordTextField.text?.characters.count>0
        {
            emailTextField.resignFirstResponder()
            if sessionIDtextfield.text?.characters.count == 0
            {
                emailTextField.becomeFirstResponder()
            }
        }
//        else if textField == sessionIDtextfield && sessionIDtextfield.text?.characters.count>0
//        {
//            delegate!.didSetSessionID(sessionIDtextfield.text!)
//           // setSessionIDName(sessionIDtextfield.text!)
//            sessionIDtextfield.resignFirstResponder()
//        }
        return false
    }
    
    // Helper funcs
    
    func keyboardDidShow(notification: NSNotification)
    {
        let height = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        toolbarBottomConstraint.constant = height!
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        toolbarBottomConstraint.constant = 0.0
    }
    

    
    
    
}




