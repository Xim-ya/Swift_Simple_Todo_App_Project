//
//  ViewController.swift
//  Todo
//
//  Created by 이해주 on 2022/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    // State Variables
    var todoList = [Todo]() {
        // Observer Property
        didSet {
            self.saveTodotoLocal()
        }
    }
    
    
    // Subviews Interface
    lazy var addButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tapAddButton))
        
        return btn
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(tapEditButton))
        
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    
    override func viewDidLayoutSubviews() {
        self.title = "Todo"
        self.navigationItem.leftBarButtonItem = self.editButton
        self.navigationItem.rightBarButtonItem = self.addButton
        
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.loadTodoFromLocal()
    }
    
    /* MARK: Intent */
    
    @objc func tapEditButton() {
        let selectedMode = self.editButton.title
        
        if selectedMode == "Edit" {
            self.editButton.title = "Done"
            self.tableView.setEditing(true, animated: true)
        } else {
            quitEditing()
        }
    }
    
    func quitEditing() {
        self.editButton.title = "Edit"
        self.tableView.setEditing(false, animated: true)
    }
    
    
    @objc func tapAddButton() {
        let alert = UIAlertController(title: "Todo", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.addTodo(alert)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.addTextField { textField in
            textField.placeholder = "Add Your Todo"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTodo(_ alert: UIAlertController) {
        guard let textInput = alert.textFields?[0].text else { return }
        self.todoList.append(Todo(title: textInput, isDone: false))
        self.tableView.reloadData()
    }
    
    

    
    
    
    /* MARK: Intent (Local DB) */
    func saveTodotoLocal() {
        let userDefaults = UserDefaults.standard
        let data = self.todoList.map {
            [
                "title" : $0.title,
                "isDone" : $0.isDone
            ]
        }
        userDefaults.set(data, forKey: "todo")
    }
    
    
    func loadTodoFromLocal() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "todo") as? [[String : Any]] else { return }
        
        todoList = data.compactMap({
            guard let title = $0["title"] as? String else { return nil }
            guard let isDone = $0["isDone"] as? Bool else { return nil }
            return Todo(title: title, isDone: isDone)
        })
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    /* DataSource */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = self.todoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = todo.title
        cell.textLabel?.text = title
        
        if todo.isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.todoList.remove(at: indexPath.row)
        self.tableView.reloadData()
        
        if todoList.isEmpty {
            quitEditing()
        }
    }
    
    /* Move Todo Item */
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = self.todoList[sourceIndexPath.row]
        self.todoList.remove(at: sourceIndexPath.row)
        self.todoList.insert(todo, at: destinationIndexPath.row)
    }
    
    
    
    /* Delegate */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.todoList[indexPath.row]
        
        self.todoList[indexPath.row] = Todo(title: todo.title, isDone: !todo.isDone)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

