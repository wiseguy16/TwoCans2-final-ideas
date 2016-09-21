//
//  Message.swift
//  TwoCans2
//
//  Created by Gregory Weiss on 9/19/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import Foundation
import Firebase

class Message
{
    var name: String = ""
    var request: String = ""
    var completed: Bool = false
    var removeRequest: Bool = false
    
    func convertMessageToFIRData() -> [String: AnyObject]
    {
        return ["name": name, "request": request, "completed": completed, "removeRequest": removeRequest]
    }
    
    func convertMessageToSnapshot(aMsg: Message) -> [String: AnyObject]
    {
        
        let name = aMsg.name
        let request = aMsg.request
        let completed = aMsg.completed
        let removeRequest = aMsg.removeRequest
        
        let messageData = ["name": name, "text": request, "completed": completed, "removeRequest": removeRequest]
        
        return messageData as! [String : AnyObject]
        
    }
    
//    func convertSnapshotToMessage(aSnap: FIRDataSnapshot) -> Message
//    {
//        let aMessage: Message
//        let message = aSnap.value as! Dictionary<String, AnyObject>
//        if let name = message["name"], let request = message["text"], let completed = message["completed"], let removeRequest = message["removeRequest"]
//        {
//            aMessage.name = name as! String
//            aMessage.request = request as! String
//            aMessage.completed = completed as! Bool
//            aMessage.removeRequest = removeRequest as! Bool
//        }
//        return aMessage
//    }


    
}
