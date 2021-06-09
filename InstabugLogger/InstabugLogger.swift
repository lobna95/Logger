//
//  InstabugLogger.swift
//  InstabugLogger
//
//  Created by Yosef Hamza on 19/04/2021.
//

import Foundation
import CoreData

public class InstabugLogger {
    public static var shared = InstabugLogger()
    
    let identifier: String  = "com.Instabug.InstabugLogger"
    let model: String       = "logModel"
    
    var persistentContainer: NSPersistentContainer {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        return container
    }
    
    // MARK: Logging
    public func log(level: Int16, message: String) {
        let context = persistentContainer.viewContext
        let log = NSEntityDescription.insertNewObject(forEntityName: "LogsEntity", into: context) as! LogsEntity
        
        let fetchRequest = NSFetchRequest<LogsEntity>(entityName: "LogsEntity")
        var newMsg : String
        let trimToCharacter = 1000
        if message.count > trimToCharacter{
            newMsg = String(message.prefix(trimToCharacter)) + "..."
            print(newMsg)
        }else{
            newMsg = message
        }
        
        do {
            let count = try context.count(for: fetchRequest)
            if count <= 1000{
                log.msg = newMsg
                log.level = level
                log.timeStamp = Date()
                
                if saveContext(message: "Create Log", context: context){
                    print("✅ Log \(newMsg) saved succesfuly")
                }
            }else{
                do{
                    if deleteEarlistLog(){
                        log.msg = newMsg
                        log.level = level
                        log.timeStamp = Date()
                        
                        if saveContext(message: "Save Log", context: context){
                            print("✅ Log \(newMsg) saved succesfully after Deleting")
                        }
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Fetch logs
    //    #warning("Replace Any with an appropriate type")
    public func fetchAllLogs() -> [LogsEntity]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<LogsEntity>(entityName: "LogsEntity")
        
        do{
            let logs = try context.fetch(fetchRequest)
            print("✅ Logs Fetched Successfully")
            return logs
        }catch let fetchErr {
            print("❌ Failed to fetch Log:",fetchErr)
        }
        return nil
        
    }
    
//    #warning("Replace Any with an appropriate type")
    public func fetchAllLogs(completionHandler: ([LogsEntity]?)->Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<LogsEntity>(entityName: "LogsEntity")
        
        do{
            let logs = try context.fetch(fetchRequest)
            completionHandler(logs)
        }catch let fetchErr {
            print("❌ Failed to fetch Log:",fetchErr)
            completionHandler(nil)
        }
    }
    
    
    public func clearLogs(){
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LogsEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("✅ Deleted All Logs Successfully")
        } catch let error as NSError {
            print("❌ Faild to delete Logs: ", error)
        }
    }
    
    func deleteEarlistLog() -> Bool{
        let context = persistentContainer.viewContext
        let request:NSFetchRequest = LogsEntity.fetchRequest()
        
        let sortDescriptor1 = NSSortDescriptor(key: "timeStamp", ascending: true)
        
        request.sortDescriptors = [sortDescriptor1]
        
        request.fetchLimit = 1
        
        do {
            let log = try context.fetch(request)
            let message = log.first!.msg
            context.delete(log.first!)
            
            if saveContext(message: "Delete \(String(describing: message))", context: context){
                print("✅ Deleted \(String(describing: message)) Log Successfully")
                return true
            }
        } catch let error as NSError {
            print("❌ Faild to Find Log: ", error)
        }
        return false
    }
    
    func saveContext(message: String, context: NSManagedObjectContext) -> Bool{
        do{
            try context.save()
            print("✅ Saved Successfully")
            return true
        }catch let error as NSError {
            print("❌ Faild to \(message) Log: ", error)
            return false
        }
    }
}
