//
//  CoreDataManager.swift
//  UniversityApplication
//
//  Created by Muhammet Ali Yahyaoğlu on 5.04.2024.
//




import Foundation
import CoreData

class CoreDataManager{
    public static let shared = CoreDataManager()
    
    let persistentContainer:NSPersistentContainer={
        let container=NSPersistentContainer(name: "UniversityModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error{
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()
    @discardableResult
    func createExample(model: University) -> UniversityModel? {
        let context = persistentContainer.viewContext
        let example = NSEntityDescription.insertNewObject(forEntityName: "UniversityModel", into: context) as! UniversityModel
        example.name = model.name
        example.adress = model.adress
        example.email = model.email
        example.fax = model.fax
        example.phone = model.phone
        example.rector = model.rector
        example.website = model.website
        do {
            try context.save()
            print("Example created successfully: \(example)")
            return example
        } catch let createError {
            print("Failed to create example: \(createError)")
        }
        return nil
    }


    func fetchExamples()->[UniversityModel]?{
        let context=persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UniversityModel>(entityName: "UniversityModel")
        do{
            let examples=try context.fetch(fetchRequest)
            return examples
        }
        catch let fetchError{
            print("Failed to fetch companies:\(fetchError) ")
        }
        return nil
    }
    func fetchExample(withName name:String)->UniversityModel?{
        let context=persistentContainer.viewContext
        let fetchRequest=NSFetchRequest<UniversityModel>(entityName: "UniversityModel")
        fetchRequest.fetchLimit=1
        fetchRequest.predicate=NSPredicate(format: "name == %@", name)
        do{
            let examples = try context.fetch(fetchRequest)
            return examples.first
        }
        catch let fetchError{
            print("Failed to error :\(fetchError)")
        }
        return nil
    }
    func deleteExample(byName name: String) {
        let context = persistentContainer.viewContext
        if let example = fetchExample(withName: name) {
            context.delete(example)
            do {
                try context.save()
                print("Example named '\(name)' deleted successfully")
            } catch let deleteError {
                print("Failed to delete: \(deleteError)")
            }
        } else {
            print("No example found with the name '\(name)'")
        }
    }
}



