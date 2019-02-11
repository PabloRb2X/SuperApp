//
//  TaskView.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/21/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import UIKit

protocol TaskViewDelegate {
    func plusItemAction()
    func editItemAction()
    func taskNameFieldDidChange(_ textfield: UITextField)
}

public class TaskView: UIView{
    
    var view: UIView!
    var tableView: UITableView!
    
    var tasksDelegate: TaskViewDelegate!

    public func initView(view: UIView, navigationBarFrame: CGRect) -> UIView{
        self.view = view
        
        tableView = UITableView(frame: CGRect(x: 0, y: navigationBarFrame.height + navigationBarFrame.origin.y, width: view.frame.width, height: view.frame.height - navigationBarFrame.height), style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.gray
        view.addSubview(tableView)
        
        return view
    }
    
    func getBarRightItems() -> [UIBarButtonItem]{
        let plusItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusItemAction))
        
        let editItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItemAction))
        
        return [plusItem, editItem]
    }
    
    @objc func plusItemAction(){
        tasksDelegate.plusItemAction()
    }
    
    @objc func editItemAction(){
        tasksDelegate.editItemAction()
    }
    
    @objc func taskNameFieldDidChange(_ textfield: UITextField){
        tasksDelegate.taskNameFieldDidChange(textfield)
    }
    
    func displayAlertToAddTask(_ updatedTask:Task!, controllerReference: TasksController){
        
        var title = "New Task"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Task"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your task.", preferredStyle: UIAlertController.Style.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertAction.Style.default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if updatedTask != nil{
                // update mode
                RealmModel.sharedInstance.updatedTask(updatedTask: updatedTask, taskName: taskName, controllerReference: controllerReference)
                
            }
            else{
                
                let newTask = Task()
                newTask.name = taskName!
                
                RealmModel.sharedInstance.addNewTask(newTask: newTask, controllerReferenece: controllerReference)
            }
            
            print(taskName ?? "")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        controllerReference.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task Name"
            textField.addTarget(self, action: #selector(self.taskNameFieldDidChange(_:)) , for: UIControl.Event.editingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        controllerReference.present(alertController, animated: true, completion: nil)
    }
    
    func getDeleteAction(indexPath: IndexPath, controllerReference: TasksController) -> UITableViewRowAction{
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            var taskToBeDeleted: Task!
            if indexPath.section == 0{
                taskToBeDeleted = controllerReference.openTasks[indexPath.row]
            }
            else{
                taskToBeDeleted = controllerReference.completedTasks[indexPath.row]
            }
            
            RealmModel.sharedInstance.deleteTask(taskToBeDeleted: taskToBeDeleted, controllerReference: controllerReference)
        }
        
        return deleteAction
    }
    
    func getEditAction(indexPath: IndexPath, controllerReference: TasksController) -> UITableViewRowAction{
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            var taskToBeUpdated: Task!
            if indexPath.section == 0{
                taskToBeUpdated = controllerReference.openTasks[indexPath.row]
            }
            else{
                taskToBeUpdated = controllerReference.completedTasks[indexPath.row]
            }
            
            self.displayAlertToAddTask(taskToBeUpdated, controllerReference: controllerReference)
            
        }
        
        return editAction
    }
    
    func getDoneAction(indexPath: IndexPath, controllerReference: TasksController) -> UITableViewRowAction{
        let doneAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Done") { (doneAction, indexPath) -> Void in
            // Editing will go here
            var taskToBeUpdated: Task!
            if indexPath.section == 0{
                taskToBeUpdated = controllerReference.openTasks[indexPath.row]
            }
            else{
                taskToBeUpdated = controllerReference.completedTasks[indexPath.row]
            }
            
            RealmModel.sharedInstance.doneTask(taskToBeUpdated: taskToBeUpdated, controllerReference: controllerReference)
        }
        
        return doneAction
    }
}
