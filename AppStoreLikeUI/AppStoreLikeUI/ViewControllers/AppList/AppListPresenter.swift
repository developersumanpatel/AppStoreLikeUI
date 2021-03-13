//
//  AppListPresenter.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import Foundation
import CoreData

class AppListPresenter {
    private weak var delegate: AppListDelegate?
    private var dataContainter = AppDelegate.shared.persistentContainer
    var rows: [AppListPresenter.Row] = []
    
    init(viewDelegate: AppListDelegate) {
        self.delegate = viewDelegate
    }
    
    func getTopAppList(isFree: Bool) {
        CoredataManager.shared.getTopApps(isFree: isFree) { (success, result) in
            debugPrint(result)
            if success, let result = result as? [String: Any] {
                if let feed = result["feed"] as? [String: Any], let results = feed["results"] as? [[String: Any]], let title = feed["title"] as? String {
                    
                    self.dataContainter.viewContext.saveContext()
                    self.dataContainter.performBackgroundTask { (backgroundContext) in
                        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        do {
                            try self.storeTopFreeApps(data: results, title: title, context: backgroundContext)
                            self.updateAppList()
                        } catch (let error) {
                            self.delegate?.finishWithError(error.localizedDescription)
                        }
                    }
                }
            } else {
                self.updateAppList()
                self.delegate?.finishWithError("There is some issue with netowrk call.")
            }
        }
    }
    
    private func storeTopFreeApps(data: [[String:Any]], title: String, context: NSManagedObjectContext) throws {
        let allApps = fetchAllApps()
        for obj in data {
            let filtered = allApps.filter{return $0.value(forKey: "id") as? String == obj["id"] as? String}
            if let first = filtered.first {
                first.name = obj["name"] as? String
                first.artistName = obj["artistName"] as? String
                first.artworkUrl100 = obj["artworkUrl100"] as? String
                first.copyright = obj["copyright"] as? String
                first.url = obj["url"] as? String
                first.feedName = title
                first.isMarkedDeleted = false
                
                if let genres = obj["genres"] as? [[String:Any]] {
                    let index: Int = 0
                    for genre in genres {
                        if index == 0 {
                            first.genre = genre["name"] as? String
                            break
                        }
                    }
                }
                
                
                context.saveContext()
                continue
            }
            add(obj: obj, title: title, context: context)
            context.saveContext()
        }
        let appData = getFeedData(title)
        for obj in appData {
            let filtered = data.filter{return $0["id"] as! String == obj.value(forKey: "id") as! String}
            if filtered.count == 0 {
                obj.isMarkedDeleted = true
                context.saveContext()
            }
        }
    }
    
    func getFeedData(_ feedName: String) -> [Results] {
        let resultRequest = NSFetchRequest<Results>(entityName: "Results")
        resultRequest.returnsObjectsAsFaults = false
        resultRequest.predicate = NSPredicate(format: "feedName == %@", "\(feedName)")
        return fetchResultRequest(request: resultRequest) ?? []
    }
    
    private func add(obj: [String:Any], title: String, context: NSManagedObjectContext) {
        let result = NSEntityDescription.insertNewObject(forEntityName: "Results", into: context) as! Results
        result.setValue(obj["name"], forKey: "name")
        result.setValue(obj["artistName"], forKey: "artistName")
        result.setValue(obj["id"], forKey: "id")
        result.setValue(obj["artworkUrl100"], forKey: "artworkUrl100")
        result.setValue(obj["copyright"], forKey: "copyright")
        result.setValue(obj["url"], forKey: "url")
        result.setValue(title, forKey: "feedName")
        result.setValue(false, forKey: "isMarkedDeleted")
        
        if let genres = obj["genres"] as? [[String:Any]] {
            let index: Int = 0
            for genre in genres {
                if index == 0 {
                    result.setValue(genre["name"], forKey: "genre")
                    break
                }
            }
        }
    }
    
    private func fetchAllApps() -> [Results] {
        var arr = [Results]()
        let request = NSFetchRequest<Results>(entityName: "Results")
        do {
            let context = self.dataContainter.viewContext
            arr = try context.fetch(request)
        } catch {
            print("Failed")
        }
        return arr
    }
    
    func updateAppList() {
        rows.removeAll()
        var feedList = fetchAllApps().map({$0.feedName})
        feedList = feedList.removeDuplicates()
        for item in feedList {
            let resultRequest = NSFetchRequest<Results>(entityName: "Results")
            resultRequest.returnsObjectsAsFaults = false
            resultRequest.predicate = NSPredicate(format: "feedName == %@ && isMarkedDeleted == %d", "\(item ?? "")", false)
            let appData = fetchResultRequest(request: resultRequest) ?? []
            if appData.count > 0 {
                rows.append(.header(item ?? ""))
            }
            var index: Int = 0
            for sameFeedData in appData {
                index += 1
                if index > 3 {
                    break
                }
                rows.append(.result(sameFeedData, index, index == 3))
            }
        }
        
        self.delegate?.finishWithSuccess()
    }
    
    private func fetchResultRequest(request: NSFetchRequest<Results>) -> [Results]? {
        do {
            let context = self.dataContainter.viewContext
            let results = try context.fetch(request)
            return results
        } catch {
            print("Failed")
        }
        
        return []
    }
}

extension AppListPresenter {
    enum Row {
        case header(String)
        case result(Results, Int, Bool)
    }
    
    func row(for indexPath: IndexPath) -> Row {
        return rows[indexPath.row]
    }
}
