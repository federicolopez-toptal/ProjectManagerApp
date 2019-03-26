//
//  Survey.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 25/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


struct Question {
    enum QuestionType {
        case text
        case yes_no
        case multiple
        case scale
    }
    
    var text: String
    var type: QuestionType
    var settings: [String]
}



struct Survey {
    
    var surveyID = ""
    var title = ""
    var description: String?
    var questions = [Question]()
    
    mutating func reset() {
        surveyID = ""
        title = ""
        description = ""
        questions = [ Question(text: "", type: .text, settings: []) ]
    }
}
