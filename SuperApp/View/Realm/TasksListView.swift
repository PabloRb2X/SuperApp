//
//  TasksListView.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/20/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import UIKit

protocol TasksListDelegate {
    func plusItemAction()
    func editItemAction()
    func segmentedControlAction(sender: UISegmentedControl)
    func listNameFieldDidChange(_ textField: UITextField)
}

public class TasksListView: UIView{
    
    var view: UIView!
    var tableView: UITableView!
    
    var tasksListDelegate: TasksListDelegate!
    
    func initView(view: UIView, navigationBarFrame: CGRect) -> UIView{
        self.view = view
        
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["A-Z", "Date"])
        segmentedControl.frame = CGRect(x: 0, y: navigationBarFrame.origin.y + navigationBarFrame.height, width: view.frame.width, height: view.frame.height * 0.05)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.blue
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction(sender:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        tableView = UITableView(frame: CGRect(x: 0, y: segmentedControl.frame.height + segmentedControl.frame.origin.y, width: segmentedControl.frame.width, height: view.frame.height - segmentedControl.frame.height - navigationBarFrame.height), style: UITableView.Style.plain)
        view.addSubview(tableView)
        
        return view
    }
    
    func getBarRightItems() -> [UIBarButtonItem]{
        let plusItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusItemAction))
        
        let editItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItemAction))
        
        return [plusItem, editItem]
    }
    
    func displayAlertToAddTaskList(_ updatedList: TaskList!, controllerReference: TasksListController){
        var title = "New Tasks List"
        var doneTitle = "Create"
        if updatedList != nil{
            title = "Update Tasks List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your tasks list.", preferredStyle: UIAlertController.Style.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertAction.Style.default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil{
                // update mode
/*
                try! uiRealm.write{ () -> Void in
                    updatedList.name = listName!
                    controllerReference.readTasksAndUpdateUI()
                }
*/
                RealmModel.sharedInstance.updatedTaskList(updatedList: updatedList, listName: listName!, controllerReference: controllerReference)
            }
            else{
                
                let newTaskList = TaskList()
                newTaskList.name = listName!
                
                //do {
/*
                try! uiRealm.write{ () -> Void in
                    
                    uiRealm.add(newTaskList)
                    controllerReference.readTasksAndUpdateUI()
                }
*/
                /*}
                 catch let error as NSError {
                 print("Something went wrong: \(error.localizedDescription)")
                 }*/
                RealmModel.sharedInstance.addNewTaskList(newTaskList: newTaskList, controllerReference: controllerReference)
            }
            
            print(listName ?? "")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        controllerReference.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(self.listNameFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        controllerReference.present(alertController, animated: true, completion: nil)
    }
    
    @objc func plusItemAction(){
        tasksListDelegate.plusItemAction()
    }
    
    @objc func editItemAction(){
        tasksListDelegate.editItemAction()
    }
    
    @objc func segmentedControlAction(sender: UISegmentedControl){
        tasksListDelegate.segmentedControlAction(sender: sender)
    }
    
    @objc func listNameFieldDidChange(_ textfield: UITextField){
        tasksListDelegate.listNameFieldDidChange(textfield)
    }
}
