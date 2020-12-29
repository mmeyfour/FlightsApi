//
//  ViewController.swift
//  FlightsApi
//
//  Created by Mersad Meyfour Asadi on 27/12/20.
//
// 0. https://github.com/mrlynn/beginner-ios-realm
// 1. https://www.youtube.com/watch?v=1N86Ak2uTXc

import UIKit
// 7. realmSwift import
import RealmSwift
// 8. class creation

class ContactItem: Object {

    // @objc dynamic -> to be exposed for Realm, beacouse its in ObjectiveC
    @objc dynamic var destination = ""
    @objc dynamic var date = ""
    @objc dynamic var flightNumber = ""
    // to be generated automaticlly
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    convenience init(destination:String, date:String, flightNumber:String, _id:String){
        self.init()
        self.destination = destination
        self.date = date
        self.flightNumber = flightNumber
        // self._id = _id -> Dont need it beacouse it`s generated !
    }
    // 11. to generate a primarykey
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class ViewController: UIViewController {
    // 1. add IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // 9. create mike object
    let mike = ContactItem(destination: "US", date: "2015/1/4", flightNumber: "N956UW", _id: "0")
    // 10. creaete people array
    //var people = [ContactItem]()
    // 12. change pople
    var people = try! Realm().objects(ContactItem.self).sorted(byKeyPath: "flightNumber", ascending: true)
    // 13. Realm database
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 4.  connect the Delegate & Datasource
        tableView.delegate = self
        tableView.dataSource = self
        // 11. add mike to the array
        //people.append(mike)
        
        // 14. database connect
        if realm.isEmpty {
            try! realm.write{
                realm.add(mike)
            }
        }
        
        let path = realm.configuration.fileURL?.path
        // this is the path where persistance data is located !
        print("Path: \(String(describing: path))")
    }
    // 15. add action for barButton
    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        
        // 16. add alert
        let alertController = UIAlertController(title: "add Flight", message: "", preferredStyle: .alert)
        
        // When the useer click the add button, present them with a dialog to enter the task name.
        
        alertController.addAction(UIAlertAction(title: "save", style: .default, handler: { alert -> Void in
            let destinationField = alertController.textFields![0] as UITextField
            let fromField = alertController.textFields![1] as UITextField
            let numberField = alertController.textFields![2] as UITextField
            let dateField = alertController.textFields![3] as UITextField
            
            // Create a new Task with the next user entered.
            let newFlight = ContactItem(destination: "\(fromField.text!) -> \(destinationField.text!)", date: dateField.text!, flightNumber: numberField.text!, _id: "")
            
            // Any writes to the Realm must occur in a write block.
            try! self.realm.write {
                // add the Task to the Realm
                self.realm.add(newFlight)
                self.tableView.reloadData()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {
            (destinationField: UITextField!) -> Void in
            destinationField.placeholder = "Destination"
        })
        alertController.addTextField(configurationHandler: {
            (fromField: UITextField!) -> Void in
            fromField.placeholder = "From"
        })
        alertController.addTextField(configurationHandler: {
            (numberField: UITextField!) -> Void in
            numberField.placeholder = "Flight Number"
        })
        alertController.addTextField(configurationHandler: {
            (dateField: UITextField!) -> Void in
            dateField.placeholder = "yyyy/mm/dd"
        })
        
        self.present(alertController, animated: true)
    }

}
/*
// 2. create de extention Delegate
extension ViewController: UITableViewDelegate {
    
}
// 3. create the extention DataSource
extension ViewController: UITableViewDataSource {
    // 5. Fix it!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many tab i have !
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // what`s inside the tab !
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // withIdentifier -> I use the same identifier at the "Prototype Cells"
        cell.textLabel?.text = people[indexPath.row].flightNumber
        cell.detailTextLabel?.text = people[indexPath.row].date
        return cell
    }
}
// 6. Install RealmSwift at directori by Terminal
*/

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // withIdentifier -> I use the same identifier at the "Prototype Cells"
        cell.textLabel?.text = people[indexPath.row].destination
        cell.detailTextLabel?.text = people[indexPath.row].date
        return cell
    }
}
