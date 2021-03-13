//
//  Extensions.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import CoreData
import UIKit
extension NSManagedObjectContext {
    
    public func saveOrRollback() -> Bool {
        do {
            if self.hasChanges {
                try save()
                return true
            }
            return true
        } catch let error {
            rollback()
            debugPrint("----->>  Rollback Error: \(error)")
            return false
        }
    }
    
    func saveContext() {
        _ = saveOrRollback()
    }
}

class CustomButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.textAlignment = .center
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}

class CustomImageView: UIImageView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
