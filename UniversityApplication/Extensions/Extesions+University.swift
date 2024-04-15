//
//  Extesions+University.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 12.04.2024.
//

import Foundation
import CoreData


//Apidan çektiğimiz datamızdaki University modelimizi core datamızdaki UniversityModele dönüştürülmesi için yazdığımız bir extensiondur.


extension University {
    func toManagedObject(in context: NSManagedObjectContext) -> UniversityModel {
        let universityModel = UniversityModel(context: context)
        universityModel.name = name
        universityModel.phone = phone
        universityModel.fax = fax
        universityModel.website = website
        universityModel.email = email
        universityModel.adress = adress
        universityModel.rector = rector
        return universityModel
    }
}
