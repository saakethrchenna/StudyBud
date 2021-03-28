//
//  JobTransmitterAndReceiver.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

class JobTransmitterAndReceiver: ObservableObject {
    
    @AppStorage("client_id") var client_id: String = "NONE"
    
    @Published var questionSets = [QuestionSet]()
    
    var socketTask: URLSessionWebSocketTask?
    
    init(preview: Bool = false) {
        if preview {
            self.previewData()
        }
    }
    
    func initializeConnection() {
        let url = NetConfig.WS_ROOT
        print(url)
        socketTask = URLSession.shared.webSocketTask(with: URL(string: url)!)
        
        socketTask?.resume()
        
        receive()
        print("Connection Initialized")
    }
    
    func previewData() {
        questionSets = [
            QuestionSet(
                webpage_name: "Demo One Hello Testing",
                webpage_url: "https://youtube.com",
                relevant_webpages: [
                    RelevantWebpage(name: "Apple", url: "https://apple.com"),
                    RelevantWebpage(name: "Google", url: "https://google.com"),
                    RelevantWebpage(name: "Amazon", url: "https://amazon.com")
                ], questions: [
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society?",
                        question_type: .BOOL,
                        correct_answer: "42",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                        possible_answers: ["40", "41", "43"]),
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society?",
                        question_type: .MCQ,
                        correct_answer: "42",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                        possible_answers: ["40", "41", "43"]),
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society?",
                        question_type: .FRQ,
                        correct_answer: "42",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                        possible_answers: []),
                ]),
            QuestionSet(
                webpage_name: "Demo Two",
                webpage_url: "https://youtube.com",
                relevant_webpages: [
                    RelevantWebpage(name: "Apple", url: "https://apple.com"),
                    RelevantWebpage(name: "Google", url: "https://google.com"),
                    RelevantWebpage(name: "Amazon", url: "https://amazon.com")
                ], questions: [
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society?",
                        question_type: .BOOL,
                        correct_answer: "42",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                        possible_answers: ["40", "41", "43", "42"]),
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society?",
                        question_type: .MCQ,
                        correct_answer: "42",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                        possible_answers: ["40", "41", "43", "42"]),
                    Question(
                        question_text: "What is the meaning of life in today's increasingly divided society? There are some more details we should check because the formatting is hard coded and never tested on large inputs.",
                        question_type: .FRQ,
                        correct_answer: "42 Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity. We are testing large inputs because we should do that in order to make sure something hasn't gone wrong with the formatting.",
                        relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity. We are testing large inputs because we should do that in order to make sure something hasn't gone wrong with the formatting. Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity. We are testing large inputs because we should do that in order to make sure something hasn't gone wrong with the formatting.",
                        possible_answers: []),
                ]),

        ]
    }
    
    func dropConnection() {
        socketTask?.cancel(with: .goingAway, reason: "GOING_INTO_BACKGROUND".data(using: .ascii))
    }
    
    private func receive() {
        self.socketTask?.receive { [weak self] result in
            print(result)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let message):
                    switch message {
                    case .string(let text):
                        self?.handleReception(text)
                    case .data(let data):
                        print(data)
                    default:
                        print("Something else")
                    }
                    self?.receive()
            }
        }
    }
    
    // ALL INBOUND STUFF IS HERE
    func handleReception(_ text: String) {
        let eventname = text.components(separatedBy: "||||")[0]
        print(eventname)
        let eventdata = text.components(separatedBy: "||||")[1].data(using: .ascii)!
        print(eventdata)
        switch eventname {
        case "RETURN_CLIENT_ID":
            RETURN_CLIENT_ID_InboundF(data: eventdata)
        case "COMPLETED_JOB":
            COMPLETED_JOB_InboundF(data: try! JSONDecoder().decode(COMPLETED_JOB_Inbound.self, from: eventdata))
        default:
            print(eventname)
        }
    }
    
    private func RETURN_CLIENT_ID_InboundF(data: Data) {
        DispatchQueue.main.async(execute: { self.client_id = String(decoding: data, as: UTF8.self) })
    }
    
    private func COMPLETED_JOB_InboundF(data: COMPLETED_JOB_Inbound) {
        var newQuestionSet = QuestionSet(webpage_name: data.webpage_name, webpage_url: data.webpage_url, relevant_webpages: [], questions: [])
        for i in 0..<data.relevant_webpage_urls.count {
            let newRelevantWebpage = RelevantWebpage(name: data.relevant_webpage_names[i], url: data.relevant_webpage_urls[i])
            newQuestionSet.relevant_webpages.append(newRelevantWebpage)
        }
        for question in data.questions {
            var questionType: QuestionType = .BOOL
            if question.question_type == "frq" {
                questionType = .FRQ
            } else if question.question_type == "mcq" {
                questionType = .MCQ
            }
            
            let newQuestion = Question(question_text: question.question_text, question_type: questionType, correct_answer: question.correct_answer, relevant_text: question.relevant_text, possible_answers: question.possible_answers)
            newQuestionSet.questions.append(newQuestion)
        }
        for i in (0..<questionSets.count).reversed() {
            if questionSets[i].webpage_url == newQuestionSet.webpage_url {
                questionSets.remove(at: i)
            }
            questionSets.append(newQuestionSet)
        }
    }
    
    // ALL OUTBOUND STUFF IS HERE
    func CREATE_CLIENT_ID_OutboundF() {
        let full_string = "CREATE_CLIENT_ID"
        print(full_string)
        self.socketTask?.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func SET_CLIENT_ID_OutBoundF(client_id: String) {
        let full_string = "SET_CLIENT_ID||||\(client_id)"
        print(full_string)
        self.socketTask?.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func CREATE_JOB_OutboundF(url: String) {
        let full_string = "CREATE_JOB||||\(url)"
        print(full_string)
        self.socketTask?.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
        questionSets.append(QuestionSet(webpage_name: "Generating...", webpage_url: url, relevant_webpages: [RelevantWebpage](), questions: [Question](), loading: true))
    }
    
    func PING_SERVER_OutboundF() {
        self.socketTask?.send(.string("PING")) { [weak self] error in
            guard let _ = self else { return }
            if let error = error {
                print(error)
            }
        }
    }
}

extension Array {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
