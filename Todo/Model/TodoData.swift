//
//  TodoData.swift
//  Todo
//
//  Created by Ferrakkem Bhuiyan on 2020-09-07.
//  Copyright © 2020 Ferrakkem Bhuiyan. All rights reserved.
//

import Foundation

struct TodoListResponse: Decodable {
    //let userId: Int
    //let id: Int
    let title: String
    var completed: Bool
}



