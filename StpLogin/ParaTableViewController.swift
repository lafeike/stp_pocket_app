//
//  ParaTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-05.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//
//  Display paragraphes under a section

import UIKit
import MarkupKit

class ParaTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var sectionKey: Int? // sectionKey will be passed from section controller.
    var offline: Bool = false // offline will be passed from section controller.
    var paraKey: Int?
    
    var paraNumArray: Array<String> = Array<String>()
    var paraKeyArray: Array<Int> = Array<Int>()
    var questionArray: Array<String> = Array<String>()
    var guideNoteArray: Array<String> = Array<String>()
    var citationArray: Array<String> = Array<String>()
    
    var rowTapped: Int?
    var tableOffsetY: CGFloat = 0.0
    
    let sdPickerViewController = StatePickerViewController()
    let dynamicComponentName = "dynamic"
    
    var state = 0 // record the state before user change it.
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;
            
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25;
        
        tableOffsetY = tableView.contentOffset.y

        navigationItem.title = "Paragraph"
        self.navigationController?.navigationBar.topItem!.title = "Back"
        
        sdPickerViewController.modalPresentationStyle = .popover
        sdPickerViewController.tableView.delegate = self
        
        guard sectionKey != nil else {
            return
        }
        
        if offline == false {
            callWebAPI()
            if StpVariables.states.count > 1 {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SD", style: .plain, target: self, action: #selector(showSDPicker))
            }
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(signOut))
            browseLocal()
        }
    }

    
    func showSDPicker() {
        let sdPickerPresentationController = sdPickerViewController.presentationController as! UIPopoverPresentationController
        
        sdPickerPresentationController.barButtonItem = navigationItem.rightBarButtonItem
        sdPickerPresentationController.backgroundColor = UIColor.white
        sdPickerPresentationController.delegate = self
        
        present(sdPickerViewController, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    

    func signOut() {
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    
    // browse publications in local database
    func browseLocal() {
        let items = StpDB.instance.getParagraphs(key: sectionKey!)
        
        for item in items {
            let question = item.question
            let guideNote = item.guideNote
            let paraKey = item.paraKey
            let paraNum = item.paraNum
            let citation = item.citation
            
            paraNumArray.append(paraNum!)
            paraKeyArray.append(paraKey)
            
            questionArray.append(question!)
            guideNoteArray.append(guideNote!)
            
            if let ci = citation {
                citationArray.append(ci)
            } else {
                citationArray.append("")
            }
        }
    }
    
    
    // call web API to get publications list
    func callWebAPI(){
        let callParameters: String
        
        if (StpVariables.stateSelected == 0) { // no state is selected, do not need to get state difference.
            callParameters = "Para?sectionKey=\(sectionKey!)"
        } else {
            let st = StpVariables.states[StpVariables.stateSelected]
            let st1 = st.replacingOccurrences(of: " ", with: "%20")
            callParameters = "ParaController/\(sectionKey!)/\(st1)"
        }
        
        let apiURL: String = Constants.URL_END_POINT + callParameters
        guard let api = URL(string: apiURL) else {
                print("Error: cannot create URL")
                return
        }
        
        var request = URLRequest(url: api)
        request.httpMethod = "GET"
            
        let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                    print("404")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("error is \(String(describing: error)), \(response.debugDescription)")
                    //self.loginSuccess(userId: nil, error: error.debugDescription)
                    return
                }
                // parse the result as JSON
                self.extract_json(jsonData: data!)
        }
        task.resume()
    }
    
        
    func extract_json(jsonData: Data){
        let sdType = ["Auditable_Partial": "Audit", "Auditable_Full": "Audit", "Applicability": "Applicability", "ExternalRef": "External", "GeneralInfo": "Info"]
            
        guard let rb = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
                return
        }
        
        paraNumArray.removeAll()
        paraKeyArray.removeAll()
        questionArray.removeAll()
        guideNoteArray.removeAll()
        citationArray.removeAll()
        rowTapped = nil // no row is tapped again.
        
        for item in rb! {
                var question = item["question"] as? String
                let guideNote = item["guideNote"] as? String
                let paraKey = item["paraKey"] as? Int
                let paraNum = item["paraNum"] as? String
                let citation = item["citation"] as? String
                
                paraNumArray.append(paraNum!)
                paraKeyArray.append(paraKey!)
                
                for (code,value) in sdType { // simplify the type of state difference for display
                    if (question == code){
                        question = value
                    }
                }
                
                questionArray.append(question!)
                guideNoteArray.append(guideNote!)
                
                if let ci = citation {
                    citationArray.append(ci)
                } else {
                    citationArray.append("")
                }
        }
        do_table_refresh()
    }
    
        
    func do_table_refresh()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            return
        }
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.name(forSection: indexPath.section) != dynamicComponentName) { // paragraph row is tapped.
            tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row != 0 {
                rowTapped = indexPath.row
                do_table_refresh()
            }
        } else { // state differents list is tapped.
            state = StpVariables.stateSelected // record the state before user's choosing.
            StpVariables.stateSelected = indexPath.row
            
            for row in 0..<StpVariables.states.count { // set a check mark at the end of selected state in the drop down list.
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) {
                    if (row == indexPath.row) {
                        cell.accessoryType = .checkmark
                        StpVariables.stateSelected = row
                    } else {
                        cell.accessoryType = .none
                    }
                }
            }
            dismiss(animated: true, completion: nil)
            if (state != StpVariables.stateSelected) { // state changed, call web API to get the new data.
                callWebAPI()
            }
        }
    }
 
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paraNumArray.count + 1 // Why + 1? to display the detail in the first row.
    }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sdType = ["Audit", "Applicability", "External", "Info"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.layoutMargins = UIEdgeInsets.zero
        if indexPath.row == 0 {
            cell.textLabel?.textColor = UIColor(white: 114/225, alpha: 1)
            cell.backgroundColor = UIColor.white
            if let row = rowTapped { // The first row will show the contents of the tapped row
                if row != 0 {
                    if (sdType.contains(questionArray[row - 1])) {
                            cell.textLabel?.text = StpVariables.states[StpVariables.stateSelected] + "\n"
                            cell.textLabel?.text = (cell.textLabel?.text!)! + guideNoteArray[row - 1]
                    } else {
                            cell.textLabel?.text = paraNumArray[row - 1] + " " + questionArray[row - 1]
                            cell.textLabel?.text = (cell.textLabel?.text!)! + "\n\n" + guideNoteArray[row - 1]
                    }
                }
            } else { // display the first row when no row is tapped.
                if paraNumArray.count > 0 {
                        if (sdType.contains(questionArray[0])) { // do not show StateDiff in the first row.
                            cell.textLabel?.text = paraNumArray[1] + " " + questionArray[1] + "\n\n" + guideNoteArray[1]
                    } else {
                            cell.textLabel?.text = paraNumArray[0] + " " + questionArray[0] + "\n\n" + guideNoteArray[0]
                    }
                } else {
                    cell.textLabel?.text = "No data."
                }
            }
        } else {
            if (sdType.contains(questionArray[indexPath.row - 1])) {
                    cell.textLabel?.textColor = UIColor(white: 50/225, alpha: 1)
                    cell.textLabel?.text = StpVariables.states[StpVariables.stateSelected] + "-"
                    cell.textLabel?.text = (cell.textLabel?.text!)! + paraNumArray[indexPath.row - 1]
                    cell.textLabel?.text = (cell.textLabel?.text!)! + "：" + citationArray[indexPath.row - 1]
                    cell.textLabel?.text = (cell.textLabel?.text!)! + " (" + questionArray[indexPath.row - 1] + ")"
            } else {
                    cell.textLabel?.textColor = UIColor(white: 114/225, alpha: 1)
                    cell.textLabel?.text = paraNumArray[indexPath.row - 1] + "：" + citationArray[indexPath.row - 1]
            }
            if (indexPath.row == rowTapped) {
                cell.backgroundColor = UIColor(hex: StpColor.Orange)
            }else {
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
            let title = UILabel()
            title.font = UIFont(name: "Myriad Pro", size: 18)!
            title.text = "Choose a paragraph to show detail"
            title.textColor = UIColor.white
        
            header?.textLabel?.font = title.font
            header?.textLabel?.textColor = title.textColor
            header?.textLabel?.text = title.text
            header?.backgroundColor = UIColor.black
            
            return header
    }
}
