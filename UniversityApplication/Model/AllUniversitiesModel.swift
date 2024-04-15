//
//  AllUniversitiesModel.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//


import Foundation

struct AllUniversitiesModel: Codable {
    let currentPage: Int
    let totalPage: Int
    let total: Int
    let itemPerPage: Int
    let pageSize: Int
    var data: [UniversityData]
}

struct UniversityData: Codable {
    let id: Int
    let province: String
    let universities: [University]
}

struct University: Codable {
    let name: String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let adress: String
    let rector: String
}




