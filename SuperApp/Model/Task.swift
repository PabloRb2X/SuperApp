//
//  Task.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/21/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted = false
    
}
