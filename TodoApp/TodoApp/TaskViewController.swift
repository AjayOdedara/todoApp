//
//  ViewController.swift
//  TodoApp
//
//  Created by Ajay Odedara on 05/06/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit
import RealmSwift

enum Kind: Int {
    case High
    case Low
    case Normal
}


class TaskViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var lists : Results<TaskList>!
    var mainList : Results<TaskList>!
    var isEditingMode = false
    
    @IBOutlet weak var taskListsTableView: UITableView!
    @IBOutlet weak var sortSegmentCotrol: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortSegmentCotrol.selectedSegmentIndex = 0
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI(){
        self.navigationController?.view.backgroundColor = UIColor.white
        taskListsTableView.tableFooterView = UIView()
        
        mainList = uiRealm.objects(TaskList.self)
        lists = mainList
        self.taskListsTableView.setEditing(false, animated: true)
        didSelectSortCriteria(sortSegmentCotrol)
    }
    
    // MARK: - User Actions -    
    @IBAction func didSelectSortCriteria(_ sender: UISegmentedControl) {
        lists = mainList
        if sender.selectedSegmentIndex == 3 {
            self.lists = self.lists.sorted(byKeyPath: "createdAt", ascending:false)
        }else{
            self.lists = lists.filter("priority = %@", sender.selectedSegmentIndex)
        }
        self.taskListsTableView.reloadData()
    }
    
    @IBAction func didClickOnEditButton(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.taskListsTableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func didClickOnAddButton(_ sender: UIBarButtonItem) {
        displayToAddTaskList(nil)
    }
    
    
    // MARK: - User Navigation -
    func displayToAddTaskList(_ updatedList:TaskList!){
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskInformatioViewcontroller") as? TaskInformatioViewcontroller {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
                viewController.selectedList = updatedList
            }
        }
    }
    
    // MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let listsTasks = lists{
            return listsTasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        
        
        
        let list = lists[indexPath.row]
        let prio = Kind(rawValue: list.priority)
        cell?.textLabel?.text = list.name
        cell?.detailTextLabel?.text = "Priority: \((prio)!)  Tasks: \(list.tasks.count)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion
            let listToBeDeleted = self.lists[indexPath.row]
            try! uiRealm.write{
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayToAddTaskList(listToBeUpdated)
        }
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openTasks", sender: self.lists[indexPath.row])
    }
    
    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lists = mainList
        self.lists = lists.filter("name CONTAINS %@", searchText)
        self.taskListsTableView.reloadData()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let TaskDetailViewController = segue.destination as! TaskDetailViewController
        TaskDetailViewController.selectedList = sender as! TaskList
    }
    
}
