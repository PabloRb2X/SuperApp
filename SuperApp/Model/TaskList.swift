//
//  TaskList.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/21/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object{
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    let tasks = List<Task>() /// Relación 1-n con la tabla Task
}
