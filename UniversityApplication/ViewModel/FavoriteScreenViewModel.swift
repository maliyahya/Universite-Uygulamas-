//
//  FavoriteScreenViewModel.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 12.04.2024.
//

import Foundation


class FavoriteScreenViewModel:ObservableObject{
     @Published  var selectedRowIndex: Int?
     @Published  var favorites:[UniversityModel]?
}
