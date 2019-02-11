//
//  TasksController.swift
//  SuperApp
//
//  Created by Pablo Ramirez Barrientos on 11/21/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import UIKit
import RealmSwift

class TasksController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskViewDelegate {
    
    let taskView: TaskView = TaskView()
    var nameController = ""
    var tableView: UITableView!
    
    var selectedList : TaskList!
    var openTasks : Results<Task>!
    var completedTasks : Results<Task>!
    var currentCreateAction: UIAlertAction!
    
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Local functions
    
    func initView(){
        taskView.tasksDelegate = self
        
        self.view = taskView.initView(view: self.view, navigationBarFrame: (self.navigationController?.navigationBar.frame)!)
        tableView = taskView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        self.title = nameController
        self.navigationItem.rightBarButtonItems = taskView.getBarRightItems()
        self.navigationItem.leftBarButtonItem?.title = "Back"
        
        readTasksAndUpateUI()
    }
    
    func readTasksAndUpateUI(){
        
        completedTasks = self.selectedList.tasks.filter("isCompleted = true")
        openTasks = self.selectedList.tasks.filter("isCompleted = false")
        
        self.tableView.reloadData()
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func taskNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }

    // MARK: TableViewDelegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return openTasks.count
        }
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "OPEN TASKS"
        }
        return "COMPLETED TASKS"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.view.frame.height * 0.08))
        headerView.backgroundColor = UIColor.lightGray
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .left
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        var task: Task!
        if indexPath.section == 0{
            task = openTasks[indexPath.row]
        }
        else{
            task = completedTasks[indexPath.row]
        }
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = taskView.getDeleteAction(indexPath: indexPath, controllerReference: self)
        let editAction = taskView.getEditAction(indexPath: indexPath, controllerReference: self)
        let doneAction = taskView.getDoneAction(indexPath: indexPath, controllerReference: self)
        
        return [deleteAction, editAction, doneAction]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Mark: Override Methods TaskViewDelegate
    func plusItemAction() {
        taskView.displayAlertToAddTask(nil, controllerReference: self)
    }
    
    func editItemAction() {
        isEditingMode = !isEditingMode
        self.tableView.setEditing(isEditingMode, animated: true)
    }

}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
