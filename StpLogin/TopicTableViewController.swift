//
//  TopicTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-29.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit

class TopicTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
   
    var acronym: String? // passed from publication controller
    var publicationTitle: String? // passed from publication controller
    var offline: Bool = false // passed from publication controller
    var topicKey: Int? // passed to rulebook controller
    var TableData: Array<String> = Array<String>()
    var topicKeyArray: Array<Int> = Array<Int>()
    var topic: String?
    
    let sdPickerViewController = StatePickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("topic start.")
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;

        self.navigationController?.navigationBar.topItem!.title = "Back"
        
        sdPickerViewController.modalPresentationStyle = .popover
        
        guard acronym != nil else {
            debugPrint("empty acronym")
            return
        }
        
        if offline == false {
            callGetTopicsAPI()
            if acronym == "EAF" || acronym == "OF" {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SD", style: .plain, target: self, action: #selector(showSDPicker))
            }
        } else {
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Topic"
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // browse publications in local database
    func browseLocal() {
        debugPrint("browse local topics...")
        let items = StpDB.instance.getTopics(aym: acronym!)
        
        for item in items {
            let topicKey = item.topicKey
            let topic = item.topic
            //debugPrint(topicKey)
            //debugPrint(topic)
            TableData.append(topic)
            topicKeyArray.append(topicKey)
        }
    }
    
    
    // call web API to get publications list
    func callGetTopicsAPI(){
        
        // create request
        let apiURL: String = Constants.URL_END_POINT + "Topics?acronym=\(acronym!)&userid=\(StpVariables.userID!)"
        debugPrint("url: " + apiURL)
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
            self.extract_topics(jsonData: data!)
        }
        task.resume()
    }
    
        
    func extract_topics(jsonData: Data){
        
        guard let pub = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else{
            debugPrint("no data for topic.")
            return
        }
        
        debugPrint("extract topic...")
        
        // Save publication.
        StpVariables.states = ["None"]
        StpVariables.stateSelected = 0
        if let pbs = pub?["pb"] as? [String: Any] {
            if let sts = pbs["state"] as? [String] {
                StpVariables.states.append(contentsOf: sts)
            }
        }
        
        // Save topic.
        if let tps = pub?["tp"] as? [[String: Any]]{
            for item in tps {
                let topicKey = item["topicKey"] as? Int
                let topic = item["topic"] as? String
                
                debugPrint(topic)
                TableData.append(topic!)
                topicKeyArray.append(topicKey!)
            }
        }
        do_table_refresh()
    }
    
    func do_table_refresh()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRulebook" {
            if let destination = segue.destination as? RulebookTableViewController {
                destination.topicKey = topicKey
                destination.topic = topic
                destination.offline = offline
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        topicKey = topicKeyArray[row]
        topic = TableData[row]
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueRulebook", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = TableData[indexPath.row]
        cell.textLabel?.textColor = UIColor(white: 114/225, alpha: 1)
        cell.textLabel?.numberOfLines = 0
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
        let title = UILabel()
        title.font = UIFont(name: "Myriad Pro", size: 18)!
        title.text = publicationTitle
        title.textColor = UIColor.white
        
        header?.textLabel?.font = title.font
        header?.textLabel?.textColor = title.textColor
        header?.textLabel?.text = title.text
                
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }


}
