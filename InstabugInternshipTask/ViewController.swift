//
//  ViewController.swift
//  InstabugInternshipTask
//
//  Created by Yosef Hamza on 19/04/2021.
//

import UIKit
import InstabugLogger

//MARK:  Important To Read About Testing

/*
 
    I know that I need to create a sepearte .swift file for core data to be save in in-memory instead in the disk to test the application but I ran out of time
 
    Hope to hear from you soon
 
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        InstabugLogger.shared.log(level: 8, message: "Maryam")
        InstabugLogger.shared.log(level: 5, message: "Salma")
        InstabugLogger.shared.log(level: 7, message: "Hamza")
        InstabugLogger.shared.log(level: 2, message: "Lobna")
        InstabugLogger.shared.log(level: 1, message: "Youmna")
        InstabugLogger.shared.log(level: 8, message: "Hussen")
        
        InstabugLogger.shared.log(level: 5, message: "Ahmed")
        InstabugLogger.shared.log(level: 7, message: "Aly")
        InstabugLogger.shared.log(level: 2, message: "Mohamed")
        InstabugLogger.shared.log(level: 1, message: "Shaheen")
        
        InstabugLogger.shared.fetchAllLogs { (result) in
            print("Fetched")
        }
    }
}

