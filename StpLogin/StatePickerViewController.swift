//
//  StatePickerViewController.swift
//  It provides a dropdown list of states for other controllers. MarkupKit framework is imported to build the list.
//
//  Created by Rafy Zhao on 2017-03-17.
//  Copyright © 2017 Rafy Zhao. All rights reserved.
//

import UIKit
import MarkupKit

class StatePickerViewController: LMTableViewController {

    let dynamicComponentName = "dynamic"
    let cellIdentifier = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    override func loadView() {
        // build list from file States.xml, with the help of MarkupKit Framework.
        view = LMViewBuilder.view(withName: "States", owner: self, root: nil)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n: Int
        if (tableView.name(forSection: section) == dynamicComponentName) {
            n = StpVariables.states.count
        } else { // no 
            n = super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        return n
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if(tableView.name(forSection: indexPath.section) == dynamicComponentName){
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            
            cell.textLabel?.text = StpVariables.states[indexPath.row]
            if (indexPath.row == StpVariables.stateSelected){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfRows = StpVariables.states.count
        StpVariables.stateSelected = indexPath.row
        
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) {
                if (row == indexPath.row) {
                    cell.accessoryType = .checkmark
                    StpVariables.stateSelected = row
                } else {
                    cell.accessoryType = .none
                }
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}