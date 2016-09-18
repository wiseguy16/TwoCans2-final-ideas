//
//  ChatViewController.swift
//  TwoCans2
//
//  Created by Gregory Weiss on 9/16/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit
import Firebase

//protocol LoginViewControllerDelegate
//{
//    func didSetSessionID(sessionIDFromLogin: String?)
//}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate//, LoginViewControllerDelegate
{
    
    
    
    @IBOutlet weak var chatTextField: UITextField!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var drums: UIImageView!
    @IBOutlet weak var elecGuitar: UIImageView!
    @IBOutlet weak var keys: UIImageView!
    @IBOutlet weak var piano: UIImageView!
    @IBOutlet weak var click: UIImageView!
    @IBOutlet weak var acoGuitar: UIImageView!
    @IBOutlet weak var handUp: UIImageView!
    @IBOutlet weak var handDown: UIImageView!
    @IBOutlet weak var handLeft: UIImageView!
    @IBOutlet weak var handRight: UIImageView!
    
     @IBOutlet weak var singleTapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var iconLabel: UILabel!
    var caMoveIcons = false
    
    //var uniqueSessionID: String = "a"
    
    
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    var messages = Array<FIRDataSnapshot>()
     var messageRefHandles = Array<FIRDatabaseHandle>()
    var toggledCompletion = false
    
    @IBOutlet weak var chattextFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureDatabase()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if !AppState.sharedInstance.signedIn
        {
            performSegueWithIdentifier("ModalLoginSegue", sender: self)
        }
        
//        // 1
//        ref.observeEventType(.Value, withBlock: { snapshot in
            
            
            
//            self.tableview.reloadData()
//           })
//            // 2
//            var newItems = [GroceryItem]()
//            
//            // 3
//            for item in snapshot.children {
//                
//                // 4
//                let groceryItem = GroceryItem(snapshot: item as! FDataSnapshot)
//                newItems.append(groceryItem)
//            }
//            
//            // 5
//            self.items = newItems
            //tableView.reloadData()
        
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
    
    
    // MARK: - Firebase methods
    
    // When messages are added, run the withBlock
    
//    func getSessionIDFirst()
//    {
//        uniqueSessionID =
//    }
    
    func configureDatabase()
    {
        ref = FIRDatabase.database().reference()
        // Listen for new messages from Firebase
      //  refHandle = ref.child(uniqueSessionID).observeEventType(.ChildAdded, withBlock: {
        refHandle = ref.child("messages").observeEventType(.ChildAdded, withBlock: {
            (snapshot) -> Void in
            self.messages.append(snapshot)
            
            //self.messages.insert(snapshot, atIndex: 0)
            // self.tableview.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
            self.tableview.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
            
        })
        messageRefHandles.append(refHandle)
        
    }
    
    // MARK: - Tableview required methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath)
        
        // Unpack message from Firebase DataSnapshot
        
        let messageSnapshot = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        if let name = message["name"], let text = message["text"]
            
        {
            cell.textLabel?.text = name + ": " + text
        }
        
        
        return cell
    }
    
    
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // 1
//        ref.observeEventType(.Value, withBlock: { snapshot in
//            
//            // 2
//            var newItems = [GroceryItem]()
//            
//            // 3
//            for item in snapshot.children {
//                
//                // 4
//                let groceryItem = GroceryItem(snapshot: item as! FDataSnapshot)
//                newItems.append(groceryItem)
//            }
//            
//            // 5
//            self.items = newItems
//            self.tableView.reloadData()
//        })
//    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
     //   let messageToDelete = messages[indexPath.row]
//        if messages.count > 1
//        {
//        tableView.reloadData()
//        }
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let refToDelete = messages[indexPath.row]
            refToDelete.ref.removeValue()
            
         //  ref.child("messages").removeValue()
            
          //  messageRefID = ref.child("messages").childByAutoId()
            messages.removeAtIndex(indexPath.row)
         //  self.messageRefHandles.removeAtIndex(indexPath.row)
        }
        tableView.reloadData()
    }
    
    func toggleCellCheckbox(cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            
            cell.accessoryView?.tintColor = UIColor.greenColor()
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            cell.textLabel?.textColor = UIColor.greenColor()
            cell.detailTextLabel?.textColor = UIColor.greenColor()
        }
    }
    
    
    
       func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 1
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        // 2
      //  var message = messages[indexPath.row]
        // 3
        
        toggledCompletion = !toggledCompletion
        // 4
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        // 5
//        groceryItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
        tableView.reloadData()
    }
    
    // MARK: - Textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
       // if textField == chatTextField
       // {
        sendMessage(textField.text)
       // }
//        else if textField == sessionIDTextfield
//        {
//            uniqueSessionID = sessionIDTextfield.text!
//            configureDatabase()
//            tableview.reloadData()
//        }
        
        return false
    }
    
    func sendMessage(message: String?)
    {
        if let msg = message{
            if msg.characters.count > 0
            {
                if let username = AppState.sharedInstance.displayName
                {
                    let messageData = ["text": msg, "name": username]
                    
                    //Push to Firebase Database
                   // ref.child(uniqueSessionID).childByAutoId().setValue(messageData)
                    ref.child("messages").childByAutoId().setValue(messageData)
                    chatTextField.text = ""
                }
            }
        }
    }
    
    
    @IBAction func signOut(sender: UIBarButtonItem)
    {
        do {
            try FIRAuth.auth()?.signOut()
            AppState.sharedInstance.signedIn = false
            print("Sign Out successfull")
            performSegueWithIdentifier("ModalLoginSegue", sender: self)
        } catch let signOutError as NSError
        {
            print("Error signing out: \(signOutError)")
        }
        
    }
    
    
    @IBAction func sendMessageTapped(sender: UIButton)
    {
        sendMessage(chatTextField.text)
        
    }
    
    @IBAction func hideTapped(sender: UIButton) {
        
        caMoveIcons = !caMoveIcons
        
//        if chatTextField.isFirstResponder()
//        {
//            chatTextField.resignFirstResponder()
//        }
        
    }
    
    func keyboardDidShow(notification: NSNotification)
    {
        let height = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        chattextFieldConstraint.constant = height! + 4
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        chattextFieldConstraint.constant = 8.0
    }
    
    
    @IBAction func iconPressed(sender: UITapGestureRecognizer)
    {
        let name = iconLabel.text
        setTextFromIcon(name!)
    }
    
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer)
    {
        if caMoveIcons
        {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        }
        
    }
    
    func setTextFromIcon(name: String)
    {
        chatTextField.text = chatTextField.text! + name
    }
    
//    func didSetSessionID(sessionIDFromLogin: String?)
//    {
//        if let sessIDFrmLog = sessionIDFromLogin
//        {
//            uniqueSessionID = sessIDFrmLog
//        }
//    }
    
    
    
    
}

