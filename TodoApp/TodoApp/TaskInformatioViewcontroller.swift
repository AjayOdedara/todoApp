//
//  TaskInformatioViewcontroller.swift
//  TodoApp
//
//  Created by Ajay Odedara on 05/06/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit


class TaskInformatioViewcontroller: UIViewController {
    
    var selectedList : TaskList!

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var prioritySegmentControll: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        createUi()
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createUi(){
        
        if selectedList != nil{
            self.title = selectedList.name
            self.taskNameTextField.text = selectedList.name
            self.prioritySegmentControll.selectedSegmentIndex = selectedList.priority
        }else{
            self.title = "New Task"
        }
        
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        displayToAddTaskList(selectedList)
    }

    func showAlert(){
        let alertController = UIAlertController(title: "Todo App Error", message: "Please enter the task name.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func displayToAddTaskList(_ updatedList:TaskList!){
        
        if (taskNameTextField.text?.characters.count)! > 0 {
            if updatedList != nil{
                try! uiRealm.write{
                    updatedList.name = taskNameTextField.text!
                    updatedList.priority = prioritySegmentControll.selectedSegmentIndex
                }
            }
            else{
                let newTaskList = TaskList()
                
                newTaskList.name = taskNameTextField.text!
                newTaskList.priority = prioritySegmentControll.selectedSegmentIndex
                try! uiRealm.write{
                    uiRealm.add(newTaskList)
                }
                
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            showAlert()
        }
    }

}
