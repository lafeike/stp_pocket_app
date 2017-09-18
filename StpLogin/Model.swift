//
//  Model.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-22.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import Foundation

class Publication {
    let id: Int64?
    var acronym: String
    var title: String
    
    
    init(id: Int64) {
        self.id = id
        acronym = ""
        title = ""
    }
    
    init(id: Int64, acronym: String, title: String){
        self.id = id
        self.acronym = acronym
        self.title = title
        
    }
}

class Topic {
    var topicKey: Int
    var acronym: String
    var topic: String
    var releaseNum: String?
    
    init(topicKey: Int, acronym: String, topic: String, releaseNum: String?){
        self.topicKey = topicKey
        self.acronym = acronym
        self.topic = topic
        self.releaseNum = releaseNum
    }
}

class Rulebook {
    var rbKey: Int
    var topicKey: Int
    var rbName: String
    var summary: String?
    
    init(rbKey: Int, topicKey: Int, rbName: String, summary: String?){
        self.topicKey = topicKey
        self.rbKey = rbKey
        self.rbName = rbName
        self.summary = summary
    }
}

class Section {
    var sectionKey: Int
    var rbKey: Int
    var sectName: String
    
    init(sectionKey: Int, rbKey: Int, sectName: String){
        self.sectionKey = sectionKey
        self.rbKey = rbKey
        self.sectName = sectName
    }
}

class Paragraph {
    var paraKey: Int
    var sectionKey: Int
    var paraNum: String?
    var question: String?
    var guideNote: String?
    var citation: String?
    
    init(paraKey: Int, sectionKey: Int, paraNum: String?, question: String?, guideNote: String?, citation: String?){
        self.paraKey = paraKey
        self.sectionKey = sectionKey
        self.paraNum = paraNum
        self.question = question
        self.guideNote = guideNote
        self.citation = citation
    }
}



