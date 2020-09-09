//
//  DataManager.swift
//  Todo
//
//  Created by Ferrakkem Bhuiyan on 2020-09-07.
//  Copyright © 2020 Ferrakkem Bhuiyan. All rights reserved.
//

import Foundation
import RealmSwift


protocol TodoDataManagerDelegate {
    func didUpdateData(_ todoData: [TodoListResponse])
    func didFailWithError(error: Error)
}


struct DataManager {
    var delegate: TodoDataManagerDelegate?

    
    //MARK: - Fetch Todo List Information
    func fetchTodoListInformation() {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        performRequest(with: urlString)
    }
    
    //MARK: - Perform API Request
    func performRequest(with urlString: String)  {
        //Create a url
        if let url = URL(string: urlString){
            //create url Session
            let session = URLSession(configuration: .default)
            // Give the session task
             let dataTask = session.dataTask(with: url) { (data, response, error) in
                 if error != nil{
                     //print(error!)
                     self.delegate?.didFailWithError(error: error!)
                     return
                 }
                 if let safeData = data{
                    self.parseJSON(toDoListData: safeData)
                 }
             }
             // start task
             dataTask.resume()
        }
    }
    
    //MARK: - jSON parse
    func parseJSON(toDoListData: Data)  {
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode([TodoListResponse].self, from: toDoListData)
            self.delegate?.didUpdateData(jsonData)
        } catch{
            delegate?.didFailWithError(error: error)
        }
    }
    
}



