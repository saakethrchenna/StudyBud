//
//  FRQChecker.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

class FRQChecker: ObservableObject {
    @Published var state: QuestionState = .UNANSWERED
    
    func check_frq_answer(input: String, target: String) {
        let url = URL(string: NetConfig.URL_ROOT+"check_frq_answer")!
        var request = URLRequest(url: url)
        request.httpBody = try! JSONEncoder().encode(check_frq_answer_Outbound(input: input, target: target))
        request.httpMethod = "POST"
        self.state = .CHECKING
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let response_data = try? JSONDecoder().decode(check_frq_answer_Inbound.self, from: data)
            if let json_data = response_data {
                DispatchQueue.main.async {
                    if json_data.correct == true {
                        self.state = .CORRECT
                    } else {
                        self.state = .INCORRECT
                    }
                }
            }
        }
        task.resume()
    }
}
