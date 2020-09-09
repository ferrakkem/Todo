//
//  ViewController.swift
//  Todo
//
//  Created by Ferrakkem Bhuiyan on 2020-09-07.
//  Copyright © 2020 Ferrakkem Bhuiyan. All rights reserved.
//

import UIKit
import RealmSwift
import SkeletonView

class ViewController: UIViewController {
    let realm = try! Realm()
    var todoLists: Results<TodoIItemList>?
    var isCoollaspe = false
    
    var listSatus = false

    
    @IBOutlet weak var todoListTable: UITableView!
    var dataManager = DataManager()
    var listArray = [TodoListResponse]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view.showAnimatedSkeleton()
            self.dataManager.fetchTodoListInformation()
        }
      
        //MARK: - call UITableView
        loadTodoList()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.todoListTable.isSkeletonable = true
            self.todoListTable.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .wetAsphalt), animation: nil, transition: .crossDissolve(0.200))
            //self.todoListTable.showAnimatedSkeleton(usingColor: .concrete, transition: .crossDissolve(0.200))

        }
    }
    
    
    //MARK: - Setup or Register UITableView
    func setupTableView() {
        todoListTable.dataSource = self
        todoListTable.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellReuseIdentifier)
        todoListTable.separatorStyle = .none
        todoListTable.contentInsetAdjustmentBehavior = .never
        todoListTable .reloadData()
    }
    
    //MARK: - Save data
    func save(_ todoListResponses: [TodoListResponse]) {
      let realm = try! Realm()
        do{
            try realm.write{
                for response in todoListResponses {
                    let object = TodoIItemList()
                    object.title = response.title
                    object.completed = response.completed
                    realm.add(object)
                }
            }
        }catch{
            print(error)
        }
    }
    
    //MARK: - Realm data loading
    func loadTodoList() {
        let realm = try! Realm()
        todoLists = realm.objects(TodoIItemList.self)
        //print(todoLists)
        setupTableView()
        
    }
    
    //MARK: - SegmentButtonPressed
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        let segmentTag = sender.selectedSegmentIndex
        
        switch segmentTag {
        case 0:
            listSatus = true
            self.loadTodoList()
            
        case 1:
            //print(3)
            listSatus = false
            todoLists = todoLists?.sorted(byKeyPath: "completed", ascending: false)
            todoListTable.reloadData()
         
        case 2:
            listSatus = true
            todoLists = todoLists?.sorted(byKeyPath: "completed", ascending: true)
            todoListTable.reloadData()
            //print(2)
        
        default:
            print("none")
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: SkeletonTableViewDataSource, UITableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return K.cellReuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLists?.count ?? 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLists?.count ?? 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoListTable.dequeueReusableCell(withIdentifier: K.cellReuseIdentifier, for: indexPath) as! TodoListTableViewCell
        let toDoList = todoLists?[indexPath.row]
        let titleLenght = ((toDoList?.title)?.count)
        
        
        if let textLent = titleLenght{
            if textLent <= 20 {
                cell.configureCell(title: toDoList?.title ?? "")
                cell.accessoryType = .none
                cell.detailTextLabel?.isHidden = true
            }else{
                cell.configureCell(title: toDoList?.title ?? "")
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.isHidden = false
            }
        }
                
        if toDoList?.completed == true {
            cell.checkMarkOutlet.text = "✓"
        }else{
            cell.checkMarkOutlet.text = ""
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //print(listArray[indexPath.row])
        listArray[indexPath.row].completed = !listArray[indexPath.row].completed
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titleLenght = ((listArray[indexPath.row].title).count)
            if titleLenght <= 20 {
                isCoollaspe = false
            }else{
                isCoollaspe = true
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCoollaspe == true{
            return 60
        }else{
            return 45
        }
    }

    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

//MARK: - TodoDataManagerDelegate
extension ViewController: TodoDataManagerDelegate{
    func didUpdateData(_ todoData: [TodoListResponse]) {
        listArray = todoData
        save(listArray)
        
        DispatchQueue.main.async {
            self.todoListTable.hideSkeleton()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))

        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Status: \(listSatus)")
        todoLists = todoLists?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "completed", ascending: listSatus)
        todoListTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadTodoList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
