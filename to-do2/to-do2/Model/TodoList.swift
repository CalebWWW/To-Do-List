//
//  TodoList.swift
//  to-do1
//
//  Created by Hyunju Kim on 3/20/24.
//

import Foundation

class TodoList: Codable {
    
    enum Category: Int, CaseIterable {
        case daily
        case weekly
        case monthly
        case yearly
    }
    
    private var dailyTodos: [ChecklistItem] = []
    private var weeklyTodos: [ChecklistItem] = []
    private var monthlyTodos: [ChecklistItem] = []
    private var yearlyTodos: [ChecklistItem] = []
    
    //init() {
    //    var item = ChecklistItem(text: "Develop an app")
    //    dailyTodos.append(item)
    //    item = ChecklistItem(text: "Clean the room")
    //    weeklyTodos.append(item)
    //    item = ChecklistItem(text: "Walk")
    //    monthlyTodos.append(item)
    //    item = ChecklistItem(text: "Drink water")
    //    yearlyTodos.append(item)
    //}
    
    func addTodo(text: String, checked: Bool) -> ChecklistItem {
        let item = ChecklistItem(text: text, checked: checked)
        dailyTodos.append(item)
        return item
    }
    
    func getTodoList(category: Category) -> [ChecklistItem] {
        switch category {
        case .daily:
            return dailyTodos
        case .weekly:
            return weeklyTodos
        case .monthly:
            return monthlyTodos
        case .yearly:
            return yearlyTodos
        }
    }

    func addTodo(item: ChecklistItem, category: Category, index: Int = -1) {
        switch category {
        case .daily:
            if index < 0 {
                dailyTodos.append(item)
            } else {
                dailyTodos.insert(item, at: index)
            }
        case .weekly:
            if index < 0 {
                weeklyTodos.append(item)
            } else {
                weeklyTodos.insert(item, at: index)
            }
        case .monthly:
            if index < 0 {
                monthlyTodos.append(item)
            } else {
                monthlyTodos.insert(item, at: index)
            }
        case .yearly:
            if index < 0 {
                yearlyTodos.append(item)
            } else {
                yearlyTodos.insert(item, at: index)
            }
        }
    }
    
    func move(item: ChecklistItem, sourceCategory: Category, sourceIndex: Int, destinationCategory: Category, destinationIndex: Int) {
        remove(item: item, category: sourceCategory, index: sourceIndex)
        addTodo(item: item, category: destinationCategory, index: destinationIndex)
    }
    
    func remove(item: ChecklistItem, category: Category, index: Int = -1) {
        switch category {
        case .daily:
                dailyTodos.remove(at: index)
        case .weekly:
                weeklyTodos.remove(at: index)
        case .monthly:
                monthlyTodos.remove(at: index)
        case .yearly:
                yearlyTodos.remove(at: index)
        }
    }
    
    func removeSpecificItem(items: [ChecklistItem], chosenList: inout [ChecklistItem]) {
        for item in items {
            if let index = chosenList.firstIndex(of: item) {
                chosenList.remove(at: index)
            }
        }
    }
}
