//
//  QuizViewModel.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

class QuizViewModel : ObservableObject {
    
    var questionSet: QuestionSet
    var questionsHistory = [Question: QuestionState]()
    
    init(questionSet: QuestionSet) {
        self.questionSet = questionSet
        for question in questionSet.questions {
            questionsHistory[question] = .UNANSWERED
        }
    }
    var numIncomplete: Int {
        var count = 0
        for (_, state) in questionsHistory {
            if state == .UNANSWERED {
                count += 1
            }
        }
        return count
    }
    
    var numCorrect: Int {
        var count = 0
        for (_, state) in questionsHistory {
            if state == .CORRECT {
                count += 1
            }
        }
        print(count)
        return count
    }
    
    var numIncorrect: Int {
        var count = 0
        for (_, state) in questionsHistory {
            if state == .INCORRECT {
                count += 1
            }
        }
        return count
    }
    
    func updateQuestionState(_ q: Question, state: QuestionState) {
        questionsHistory[q] = state
    }
}
