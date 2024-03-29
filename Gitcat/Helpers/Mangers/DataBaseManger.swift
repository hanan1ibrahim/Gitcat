//
//  DataBaseManger.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//
import UIKit
import CoreData

class DataBaseManger {
    
    static let shared = DataBaseManger()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetch<T: NSManagedObject>(returnType: T.Type , completion: @escaping ([T]) -> Void) {
        do {
            guard let result = try context.fetch(returnType.fetchRequest()) as? [T] else {
                return
            }
            completion(result)
        } catch {
           
        }
    }
    
    func delete<T: NSManagedObject>(returnType: T.Type, delete: T) {
        context.delete(delete.self)
        do {
            try context.save()
        } catch {
            
        }
    }
}
