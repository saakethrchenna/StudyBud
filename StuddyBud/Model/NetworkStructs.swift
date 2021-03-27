//
//  NetworkStructs.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import Foundation

struct COMPLETED_JOB_Inbound: Codable {
    var client_id: String
    var webpage_name: String
    var webpage_url: String
    var relevant_webpage_urls: [String]
    var relevant_webpage_names: [String]
    var questions: [COMPLETED_JOB_InboundQuestion]
}

struct COMPLETED_JOB_InboundQuestion: Codable {
    var question_text: String
    var question_type: String
    var correct_answer: String
    var relevant_text: String
    var possible_answers: [String]
}

struct check_frq_answer_Outbound: Codable {
    var input: String
    var target: String
}

struct check_frq_answer_Inbound: Codable {
    var correct: Bool
}
