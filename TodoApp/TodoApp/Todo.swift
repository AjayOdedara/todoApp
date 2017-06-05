//
//  Todo.swift
//  TodoApp
//
//  Created by Ajay Odedara on 05/06/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import RealmSwift



class TaskList: Object {
    
    dynamic var name = ""
    dynamic var priority = 0
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}

class Task: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}


