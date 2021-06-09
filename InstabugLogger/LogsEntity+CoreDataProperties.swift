//
//  LogsEntity+CoreDataProperties.swift
//  InstabugLogger
//
//  Created by Lobna on 5/28/21.
//
//

import Foundation
import CoreData


extension LogsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogsEntity> {
        return NSFetchRequest<LogsEntity>(entityName: "LogsEntity")
    }

    @NSManaged public var msg: String?
    @NSManaged public var level: Int16
    @NSManaged public var timeStamp: Date?

}
