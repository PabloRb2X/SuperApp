//
//  RealmModel.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/20/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RealmModel{
    private var uiRealm: Realm
    static let sharedInstance = RealmModel()
    
    private init() {
        uiRealm = try! Realm()
    }
    
    func updatedTaskList(updatedList: TaskList, listName: String?, controllerReference: TasksListController){
        try! uiRealm.write{ () -> Void in
            updatedList.name = listName!
            controllerReference.readTasksAndUpdateUI()
        }
    }
    
    func updatedTask(updatedTask: Task, taskName: String?, controllerReference: TasksController){
        try! uiRealm.write{ () -> Void in
            updatedTask.name = taskName!
            controllerReference.readTasksAndUpateUI()
        }
    }
    
    func addNewTaskList(newTaskList: TaskList, controllerReference: TasksListController){
        try! uiRealm.write{ () -> Void in
            
            uiRealm.add(newTaskList)
            controllerReference.readTasksAndUpdateUI()
        }
    }
    
    func addNewTask(newTask: Task, controllerReferenece: TasksController){
        
        try! uiRealm.write{ () -> Void in
            
            controllerReferenece.selectedList.tasks.append(newTask)
            controllerReferenece.readTasksAndUpateUI()
        }
    }
    
    func deleteTaskList(listToBeDeleted: TaskList, controllerReference: TasksListController){
        try! uiRealm.write{ () -> Void in
            
            uiRealm.delete(listToBeDeleted)
            controllerReference.readTasksAndUpdateUI()
        }
    }
    
    func deleteTask(taskToBeDeleted: Task, controllerReference: TasksController){
        try! uiRealm.write{ () -> Void in
            
            uiRealm.delete(taskToBeDeleted)
            controllerReference.readTasksAndUpateUI()
        }
    }
    
    func doneTask(taskToBeUpdated: Task, controllerReference: TasksController){
        try! uiRealm.write{
            taskToBeUpdated.isCompleted = true
            controllerReference.readTasksAndUpateUI()
        }
    }
    
    func getDataFromTaskList() -> Results<TaskList> {
        let results: Results<TaskList> = uiRealm.objects(TaskList.self)
        
        return results
    }
}


/*class Task: Object{
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted = false

}

class TaskList: Object{
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    let tasks = List<Task>() /// Relación 1-n con la tabla Task
}

class Person: Object{
    @objc dynamic var name = ""
}

class Car: Object{
    @objc dynamic var owner: Person? /// Realación 1-1 con la tabla Person
}
 */

