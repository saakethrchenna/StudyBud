//
//  MainModel.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct RelevantWebpage: Identifiable,Hashable {
    var name: String
    var url: String
    let id = UUID()
}

struct QuestionSet: Identifiable,Hashable {
    
    var webpage_name: String
    var webpage_url: String
    var relevant_webpages: [RelevantWebpage]
    var questions: [Question]
    var loading: Bool = false
    let id = UUID()
}

enum QuestionType {
    case FRQ
    case MCQ
    case BOOL
}

struct Question: Identifiable,Hashable{
    var question_text: String
    var question_type: QuestionType
    var correct_answer: String
    var relevant_text: String
    var possible_answers: [String]
    let id = UUID()
}

enum QuestionState {
    case UNANSWERED
    case CHECKING
    case CORRECT
    case INCORRECT
}
