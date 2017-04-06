//
//  PubListViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-02.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit

class PubListViewController: UITableViewController {
    
    var TableData: Array<String> = Array<String>()
    var acronym: String?
    var offline = false
    var publicationTitle: String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;

        navigationItem.title = Constants.TITLE
        navigationItem.setHidesBackButton(true, animated: false)
        
       
        if offline ==  false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
            callGetPubsAPI()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(signOut))
            browseLocal()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Constants.TITLE
    }
    
    
    // browse publications in local database
    func browseLocal() {
        let pubs = StpDB.instance.getPublications()
        
        for item in pubs {
            let acronym = item.acronym
            let title = item.title
            
            TableData.append(acronym + ": " + title)
        }
    }
    
    func signOut() {
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    func showSpinner() -> UIActivityIndicatorView {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var indicator = UIActivityIndicatorView()
        indicator = UIActivityIndicatorView(frame: self.view.frame)
        indicator.center.x = self.view.center.x   + tableView.contentOffset.x
        indicator.center.y = self.view.center.y + tableView.contentOffset.y
        indicator.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.color = UIColor.red
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        self.view.addSubview(indicator)
        debugPrint("show spinner....")
        return indicator
    }
    
    func hideSpinner(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        indicator.isHidden = true
        debugPrint("hide spinner...")
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
        
    
    // call web API to get publications list
    func callGetPubsAPI(){
        
        // create request
        let apiURL: String = Constants.URL_END_POINT + "Publications?userId=\(StpVariables.userID!)"
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
                print("error is \(error), \(response.debugDescription)")
                return
            }
            // parse the result as JSON
            self.extract_publications(jsonData: data!)
        }
        task.resume()
    }
    
    
    func showAlert(msg: String){
        let alertController = UIAlertController(title:"STP in Pocket", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
            print("OK")
            
        }
        alertController.addAction(remindAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func extract_publications(jsonData: Data){
        
        guard let pubs = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
            return
        }
        
        for item in pubs! {
            let acronym = item["acronym"] as? String
            let title = item["title"] as? String
            
            TableData.append(acronym! + ": " + title!)
        }
        do_table_refresh()
    }
    
    func do_table_refresh()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
    
    
    // query what publications are there in local storage.
    func localPubList() -> Array<String> {
        return StpDB.instance.getAcronym()
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
        // debugPrint("passed userId: \(self.userId)");

        return TableData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PublicationTableViewCell
        let pubs = localPubList()
        cell.titleLabel.text = TableData[indexPath.row]
        if pubs.contains(cell.titleLabel.text!){
            cell.titleLabel.textColor = UIColor(white: 1/225, alpha: 1)
        } else {
            cell.titleLabel.textColor = UIColor(white: 114/225, alpha: 1)
        }
        let holdToDownload = UILongPressGestureRecognizer(target: self, action: #selector(longPressDownload(sender:)))
        holdToDownload.minimumPressDuration = 1.0
        cell.addGestureRecognizer(holdToDownload) 

        return cell
    }
    
    // long press to trigger download.
    func longPressDownload(sender: UILongPressGestureRecognizer) {
        if offline == true{ // do not trigger downloading when offline.
            return
        }
        if(sender.state == UIGestureRecognizerState.began){
            
            let point: CGPoint = sender.location(in: tableView)
            guard let indexPath: IndexPath = tableView.indexPathForRow(at: point) else {
                print("not press on the right area. Ignore.")
                return
            }
            let row = indexPath.row
            let cellValue = self.TableData[row]
            let range1 = cellValue.range(of: ":")
            let endInt = range1?.lowerBound
            
            //debugPrint("the row is tabbed :" + cellValue.substring(to: endInt!))
            
            let alert: UIAlertController = UIAlertController(title: "Download Publication", message: "Begin to download " + cellValue.substring(to: endInt!) + "?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (UIAlertAction) -> Void in
                let spinner = self.showSpinner()
                
                // move to a background thread to download publication.
                DispatchQueue.global(qos: .userInitiated).async {
                    self.downloadPublication(pub: cellValue.substring(to: endInt!)){ (response) in
                        if response == true {
                            DispatchQueue.main.async {
                                self.hideSpinner(indicator: spinner)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.hideSpinner(indicator: spinner)
                            }
                        }
                    }
                    
                }
            }));
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }
            
        } else if (sender.state == UIGestureRecognizerState.ended){
            print("long press end.")
        }
    }
    
    
    func downloadPublication(pub: String, completionHandler: @escaping (Bool) -> ()) {
        
        // create request
        let apiURL: String = Constants.URL_END_POINT + "Publications?acronym=\(pub)"
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
                completionHandler(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                print("404")
                //self.loginSuccess(userId: nil, error: "Bad acroynm.")
                completionHandler(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("error is \(error), \(response.debugDescription)")
                //self.loginSuccess(userId: nil, error: error.debugDescription)
                completionHandler(false)
                return
            }
            // parse the result as JSON
            // debugPrint("download successfully. begin to save the data...")
            self.save_publication(jsonData: data!)
            self.do_table_refresh()
            completionHandler(true)
           
        }
        task.resume()
    }
    
    
    func save_publication(jsonData: Data) {
        guard let pub = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else{
            return
        }
        print("loop json to extract data.")
        let db = StpDB.instance
        
        // Save publication.
        if let pbs = pub?["pb"] as? [String: Any] {
            
            guard let pid = pbs["PublicationID"] as? Int else {
                    return
                }
            guard let title = pbs["Title"] as? String else {
                    return
                }
            guard let ac = pbs["Acronym"] as? String else {
                return
            }
            debugPrint("acronym: \(ac), title: \(title), id: \(pid)")
            acronym = ac
            db.deletePublication(cacronym: ac) // delete the publication before downloading it.
            
            if db.addPublication(cacronym: ac, ctitle: title, cid: Int64(pid)) == -1 {
                print("cannot save publication: \(ac)")
                return
            }
        }
        
        // Save topic.
        if let tps = pub?["tp"] as? [[String: Any]]{
            for tp in tps {
                guard let topicKey = tp["topicKey"] as? Int else {
                    return
                }
                guard let topic = tp["topic"] as? String else {
                    return
                }
                let releaseNum = tp["releaseNum"] as? Int
                
                if db.addTopic(ctopicKey: topicKey, cacronym: acronym!, ctopic: topic, creleaseNum: String(describing: releaseNum)) == -1 {
                    print("cannot save topic: \(topic)")
                    return
                }
            }
        }
        
        // Save rulebook
        if let rbs = pub?["rb"] as? [[String: Any]]{
            for rb in rbs {
                guard let topicKey = rb["topicKey"] as? Int else {
                    return
                }
                guard let rbKey = rb["rbKey"] as? Int else {
                    return
                }
                guard let rbName = rb["rbName"] as? String else {
                    return
                }
                let summary = rb["summary"] as? String
                //debugPrint("to save rulebook: \(rbName)")
                if db.addRulebook(ctopicKey: topicKey, crbKey: rbKey, crbName: rbName, csummary: summary) == -1 {
                    print("cannot save rulebook: \(rbName)")
                    return
                }
            }
        }

        // Save section
        if let sts = pub?["st"] as? [[String: Any]]{
            for st in sts {
                guard let sectionKey = st["sectionKey"] as? Int else {
                    return
                }
                guard let rbKey = st["rbKey"] as? Int else {
                    return
                }
                guard let sectName = st["sectName"] as? String else {
                    return
                }
                
                // debugPrint("to save section: \(sectName)")
                if db.addSection(csectionKey: sectionKey, crbKey: rbKey, csectName: sectName) == -1 {
                    print("cannot save section: \(sectName)")
                    return
                }
            }
        }
        
        // Save paragraph
        if let pgs = pub?["pg"] as? [[String: Any]]{
            for pg in pgs {
                guard let sectionKey = pg["sectionKey"] as? Int else {
                    return
                }
                guard let paraKey = pg["paraKey"] as? Int else {
                    return
                }
                let paraNum = pg["paraNum"] as? String
                let question = pg["question"] as? String
                let guideNote = pg["guideNote"] as? String
                let citation = pg["citation"] as? String
                
                // debugPrint("to save paragraph: \(paraKey)")
                if db.addParagraph(cparaKey: paraKey, csectionKey: sectionKey, cparaNum: paraNum, cquestion: question, cguideNote: guideNote, ccitation: citation) == -1 {
                    print("cannot save paragraph: \(paraKey)")
                    return
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
        let title = UILabel()
        title.font = UIFont(name: "Myriad Pro", size: 18)!
        title.text = "Select a publication below"
        title.textColor = UIColor.white
        
        header?.textLabel?.font = title.font
        header?.textLabel?.textColor = title.textColor
        header?.textLabel?.text = title.text
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTopic" {
            if let destination = segue.destination as? TopicTableViewController {
                destination.acronym = acronym
                destination.publicationTitle = publicationTitle
                destination.offline = offline
            }
        }
    }
    
    // user tap the row in the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let cellValue = TableData[row]
        let range1 = cellValue.range(of: ":") // get acroynm from the cell data like 'CALO: OSHA Auditing: California Occupational'
        let endInt = range1?.lowerBound
        
        acronym = cellValue.substring(to: endInt!)
        publicationTitle = cellValue.substring(from: cellValue.index(after: endInt!))
        // print("the row is tabbed:" + acronym!)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueTopic", sender: self)
        }
    }
}
