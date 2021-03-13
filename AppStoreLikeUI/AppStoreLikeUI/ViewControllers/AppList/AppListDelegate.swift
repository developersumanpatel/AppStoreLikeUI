//
//  AppListDelegate.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import Foundation
import CoreData
protocol AppListDelegate: NSFetchedResultsControllerDelegate {
    func finishWithSuccess()
    func finishWithError(_ error: String)
}
