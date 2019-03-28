//
//  Survey.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 25/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


struct Answers {
    var userID: String
    var isATKMember: Bool
    var info: [Any]
}


struct Question {
    enum QuestionType: String {
        case text = "text"
        case yes_no = "yesNo"
        case multiple = "multiple"
        case scale = "scale"
    }
    
    var text: String
    var type: QuestionType
    var options: [String]
}



struct Survey {
    
    var surveyID = ""
    var title = ""
    var description: String?
    var created = ""
    var questions = [Question]()
    var answers = [Answers]()
    
    mutating func reset() {
        surveyID = ""
        title = ""
        description = ""
        created = ""
        questions = [ Question(text: "", type: .text, options: []) ]
    }
    
    mutating func fillWith(dict: NSDictionary) {
        surveyID = dict["id"] as! String
        let content = dict["content"] as! [String: Any]
        
        let info = content["info"] as! [String: String]
        let questions = content["questions"] as! [NSDictionary]
        
        title = info["title"]! as String
        description = info["description"]
        created = info["created"]! as String
        
        // Questions
        self.questions = [Question]()
        for Q in questions {
            let text = Q["text"] as! String
            let strType = Q["type"] as! String
            let type = Question.QuestionType(rawValue: strType)
            
            if let options = Q["options"] as? [String] {
                self.questions.append( Question(text: text, type: type!, options: options) )
            } else {
                self.questions.append( Question(text: text, type: type!, options: []) )
            }
        }
        
        // Answers
        self.answers = [Answers]()
        if let answersDict = content["answers"] as? [String: Any] {
            for (keyUserID, value) in answersDict {
                let answerContent = value as! [String: Any]
                let ATKm = answerContent["ATKMember"] as! Bool
                
                var info = [Any]()
                let infoArray = answerContent["info"] as! [Any]
                for I in infoArray {
                    info.append(I)
                }
                
                let newA = Answers(userID: keyUserID, isATKMember: ATKm, info: info)
                self.answers.append(newA)
            }
        } else {
            self.answers = [Answers]()
        }
    }
    
    
    
}
