//
//  TasksListController.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/20/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListController: UIViewController, UITableViewDelegate, UITableViewDataSource, TasksListDelegate {
    
    var tasksListView: TasksListView = TasksListView()
    var taskListsTableView: UITableView!
    
    var lists : Results<TaskList>!
    var isEditingMode = false
    
    var currentCreateAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*let taskListA = TaskList()
        taskListA.name = "Wishlist"
        
        let wish1 = Task()
        wish1.name = "iPhone6s"
        wish1.notes = "64 GB, Gold"
        
        let wish2 = Task(value: ["name": "Game Console", "notes": "Playstation 4, 1 TB"])
        let wish3 = Task(value: ["Car", NSDate(), "Auto R8", false])
        
        taskListA.tasks.append(objectsIn: [wish1, wish2, wish3])
        
        let taskListB = TaskList(value: ["MoviesList", NSDate(), [["The Martian", NSDate(), "", false], ["The Maze Runner", NSDate(), "", true]]])

        try! uiRealm.write { () -> Void in
            uiRealm.add([taskListA, taskListB])
        }*/
        
        readTasksAndUpdateUI()
    }
    
    // MARK: Local Functions
    
    func initView(){
        tasksListView.tasksListDelegate = self
        self.title = "Realm - Tasks List"
        
        self.view = tasksListView.initView(view: self.view, navigationBarFrame: (self.navigationController?.navigationBar.frame)!)
        self.navigationItem.rightBarButtonItems = tasksListView.getBarRightItems()
        taskListsTableView = tasksListView.tableView
        taskListsTableView.delegate = self
        taskListsTableView.dataSource = self
        taskListsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    }
    
    func readTasksAndUpdateUI(){
        
        lists = RealmModel.sharedInstance.getDataFromTaskList()//uiRealm.objects(TaskList.self)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    @objc func listNameFieldDidChange(_ textField: UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func displayAlertToAddTaskList(_ updatedList: TaskList!){
        
        tasksListView.displayAlertToAddTaskList(updatedList, controllerReference: self)
    }
    
    // MARK: - TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listsTasks = lists{
            return listsTasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let list = lists[indexPath.row]
        
        cell.textLabel?.text = list.name
        cell.detailTextLabel?.text = "\(list.tasks.count) Tasks"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            let listToBeDeleted = self.lists[indexPath.row]
/*
            try! uiRealm.write{ () -> Void in
                
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            }
*/
            RealmModel.sharedInstance.deleteTaskList(listToBeDeleted: listToBeDeleted, controllerReference: self)
            
        }
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayAlertToAddTaskList(listToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.row]
        
        let tasksController = TasksController()
        tasksController.nameController = list.name
        tasksController.selectedList = self.lists[indexPath.row] 
        
        self.navigationController?.pushViewController(tasksController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func plusItemAction() {
        print("plus item action")
        
        displayAlertToAddTaskList(nil)
    }
    
    func editItemAction() {
        print("edit item action")
        
        isEditingMode = !isEditingMode
        self.taskListsTableView.setEditing(isEditingMode, animated: true)
    }
    
    @objc func segmentedControlAction(sender: UISegmentedControl){
        print("segmented control value changed")
        if sender.selectedSegmentIndex == 0{
            // A-Z
            self.lists = self.lists.sorted(byKeyPath: "name")
        }
        else{
            // date
            self.lists = self.lists.sorted(byKeyPath: "createdAt", ascending: false)
        }
        
        self.taskListsTableView.reloadData()
    }
}
