//
//  AppState.swift
//  TwoCans2
//
//  Created by Gregory Weiss on 9/16/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit

class AppState: NSObject
{
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    
    

}
