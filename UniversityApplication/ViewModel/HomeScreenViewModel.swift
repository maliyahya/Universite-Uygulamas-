//
//  HomeScreenViewModel.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 4.04.2024.
//

import Foundation

class HomeScreenViewModel:ObservableObject {
    @Published var universities: [UniversityData]?
    @Published var pageNumber=1
    @Published var selectedRowIndex: Int?
    @Published var isFetchingData = false

    func setUniversities(_ universities: [UniversityData]) {
           self.universities = universities
       }
    
    
    
}
