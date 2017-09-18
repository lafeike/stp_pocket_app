//
//  StpDb.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-21.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import SQLite

class StpDB {
    
    static let instance = StpDB()
    private let db: Connection?
    
    private let contacts = Table("contacts")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let phone = Expression<String>("phone")
    private let address = Expression<String>("address")
    
    private let publication = Table("publication")
    private let acronym = Expression<String>("acronym")
    private let title = Expression<String>("title")
    private let pid = Expression<Int64>("pid")
    
    private let topic = Table("topic")
    private let topicKey = Expression<Int>("topicKey")
    private let topicName = Expression<String>("topic")
    private let releaseNum = Expression<String?>("releaseNum")
    
    private let rulebook = Table("rulebook")
    private let rbKey = Expression<Int>("rbKey")
    private let rbName = Expression<String>("rbName")
    private let summary = Expression<String?>("summary")
    
    private let section = Table("section")
    private let sectionKey = Expression<Int>("sectionKey")
    private let sectName = Expression<String>("sectName")
    
    private let paragraph = Table("paragraph")
    private let paraKey = Expression<Int>("paraKey")
    private let paraNum = Expression<String?>("paraNum")
    private let question = Expression<String?>("question")
    private let guideNote = Expression<String?>("guideNote")
    private let citation = Expression<String?>("citation")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/Stp.sqlite3")
            createTable()
        } catch {
            db = nil
            print("Unable to open database.")
        }
    }
    
    
    func createTable() {
        do {
            try db!.run(contacts.create(ifNotExists: true) { table in
                    table.column(id, primaryKey: true)
                    table.column(name)
                    table.column(phone, unique: true)
                    table.column(address)
            })
            
            try db!.run(publication.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(acronym, unique: true)
                table.column(title)
            })
            
            try db!.run(topic.create(ifNotExists: true) { table in
                table.column(topicKey, primaryKey: true)
                table.column(acronym)
                table.column(topicName)
                table.column(releaseNum)
            })
            
            try db!.run(rulebook.create(ifNotExists: true) { table in
                table.column(rbKey, primaryKey: true)
                table.column(topicKey)
                table.column(rbName)
                table.column(summary)
            })
            
            try db!.run(section.create(ifNotExists: true) { table in
                table.column(sectionKey, primaryKey: true)
                table.column(rbKey)
                table.column(sectName)
            })
            
            try db!.run(paragraph.create(ifNotExists: true) { table in
                table.column(paraKey, primaryKey: true)
                table.column(sectionKey)
                table.column(paraNum)
                table.column(question)
                table.column(guideNote)
                table.column(citation)
            })
        } catch {
          print("Unable to create table")
        }
    }
    
    
    func deletePublication(cacronym: String ) -> Int64 {
        do {
            let pbs = publication.filter(acronym == cacronym)
            
            let all = Array(try db!.prepare(pbs))
            if all.count == 0 {
                return 0
            }
            
            let tps = topic.filter(acronym == cacronym)
            for tp in try db!.prepare(tps) {
                let rbs = rulebook.filter(topicKey == tp[topicKey])
                
                for rb in try db!.prepare(rbs) {
                    let sts = section.filter(rbKey == rb[rbKey])
                    
                    for st in try db!.prepare(sts) {
                        let pgs = paragraph.filter(sectionKey == st[sectionKey])
                        try db!.run(pgs.delete())
                    }
                    try db!.run(sts.delete())
                }
                try db!.run(rbs.delete())
            }
            try db!.run(tps.delete())
            try db!.run(pbs.delete())
            return 0
        } catch {
            print("delete failed in delete publication: \(error)")
            return -1
        }
    }
    
    
    func addPublication(cacronym: String, ctitle: String, cid: Int64) -> Int64 {
        do {
            let insert = publication.insert(acronym <- cacronym, title <- ctitle, id <- cid)
            let ret = try db!.run(insert)
            
            return ret
        } catch {
            print("Error info in saving table publication: \(error)")
            return -1
        }
    }
    
    func addTopic(ctopicKey: Int, cacronym: String, ctopic: String, creleaseNum: String?) -> Int {
        do {
            var insert: Insert
            
            if let release = creleaseNum {
                insert = topic.insert(releaseNum <- release, acronym <- cacronym, topicKey <- ctopicKey, topicName <- ctopic)
                
            } else {
                print("insert topic without releaseNum")
                insert = topic.insert(acronym <- cacronym, topicKey <- ctopicKey, topicName <- ctopic)
            }
            
            let ret = try db!.run(insert)
            
            return Int(ret)
        } catch {
            print("Error info in saving table topic: \(error)")
            return -1
        }

    }
    
    func addRulebook(ctopicKey: Int, crbKey: Int, crbName: String, csummary: String?) -> Int {
        do {
            var insert: Insert
            
            if let smy = csummary {
                insert = rulebook.insert(summary <- smy, rbName <- crbName, topicKey <- ctopicKey, rbKey <- crbKey)
                
            } else {
                print("insert rulebook without summary")
                insert = topic.insert(rbName <- crbName, topicKey <- ctopicKey, rbKey <- crbKey)
            }
            
            let ret = try db!.run(insert)
            
            return Int(ret)
        } catch {
            print("Error info in saving table rulebook: \(error)")
            return -1
        }
        
    }
    
    func addSection(csectionKey: Int, crbKey: Int, csectName: String) -> Int {
        do {
            let insert = section.insert(sectionKey <- csectionKey, rbKey <- crbKey, sectName <- csectName)
            let ret = try db!.run(insert)
            
            return Int(ret)
        } catch {
            print("Error info in saving table section: \(error)")
            return -1
        }
    }

    func addParagraph(cparaKey: Int, csectionKey: Int, cparaNum: String?, cquestion: String?, cguideNote: String?, ccitation: String?) -> Int {
        do {
            
            let insert = paragraph.insert(paraKey <- cparaKey, sectionKey <- csectionKey, paraNum <- cparaNum, question <- cquestion, guideNote <- cguideNote, citation <- ccitation)
            let ret = try db!.run(insert)
            
            return Int(ret)
        } catch {
            print("Error info in saving table rulebook: \(error)")
            return -1
        }
        
    }
    
    
        
    
    
    func getPublications() -> [Publication] {
        var pubs = [Publication]()
        
        do {
            for pub in try db!.prepare(self.publication){
                pubs.append(Publication(
                    id: pub[id],
                    acronym: pub[acronym],
                    title: pub[title]))
            }
        } catch {
            print("Select failed")
        }
        
        return pubs
    }
    
    func  getAcronym() -> [String] {
        var acro = [String]()
        
        do {
            for pub in try db!.prepare(self.publication.select(acronym, title)) {
                acro.append(pub[acronym] + ": " + pub[title])
            }
        } catch {
            return []
        }
        return acro
    }
    
    
    func getTopics(aym: String) -> [Topic] {
        var items = [Topic]()
        
        do {
            for item in try db!.prepare(self.topic.filter(acronym == aym)){
                items.append(Topic(
                    topicKey: item[topicKey],
                    acronym: item[acronym],
                    topic: item[topicName],
                    releaseNum: item[releaseNum]))
            }
        } catch {
            print("Select failed")
        }
        
        return items
    }
    
    
    func getRulebooks(key: Int) -> [Rulebook] {
        var items = [Rulebook]()
        
        do {
            for item in try db!.prepare(self.rulebook.filter(topicKey == key)){
                items.append(Rulebook(
                    rbKey: item[rbKey],
                    topicKey: item[topicKey],
                    rbName: item[rbName],
                    summary: item[summary]))
            }
        } catch {
            print("Select failed")
        }
        
        return items
    }
    
    
    func getSections(key: Int) -> [Section] {
        var items = [Section]()
        
        do {
            for item in try db!.prepare(self.section.filter(rbKey == key)){
                items.append(Section(
                    sectionKey: item[sectionKey],
                    rbKey: item[rbKey],
                    sectName: item[sectName]))
            }
        } catch {
            print("Select failed")
        }
        
        return items
    }
    
    
    func getParagraphs(key: Int) -> [Paragraph] {
        var items = [Paragraph]()
        
        do {
            for item in try db!.prepare(self.paragraph.filter(sectionKey == key)){
                items.append(Paragraph(
                    paraKey: item[paraKey],
                    sectionKey: item[sectionKey],
                    paraNum: item[paraNum],
                    question: item[question],
                    guideNote: item[guideNote],
                    citation: item[citation]))
            }
        } catch {
            print("Select failed")
        }
        
        return items
    }

    



}

