//
//  Enums.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import Foundation

enum HTTPMethod:String {
    case GET
    case POST
}
enum APIError:Error{
    case failedToGetData
    case invalidResponse
}
