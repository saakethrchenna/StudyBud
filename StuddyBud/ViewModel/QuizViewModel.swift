//
//  QuizViewModel.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI



struct QuestionHistory: Identifiable {
    var question: Question
    var questionState: QuestionState
    let id = UUID()
}

extension QuestionHistory: Hashable {
    static func == (lhs: QuestionHistory, rhs: QuestionHistory) -> Bool {
        return lhs.question.question_text == rhs.question.question_text
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(question.question_text)
    }
}

class QuizViewModel : ObservableObject {
    
    var questionSet: QuestionSet
    var questionsHistory = OrderedSet<QuestionHistory>()
    
    init(questionSet: QuestionSet) {
        self.questionSet = questionSet
        for question in questionSet.questions {
            questionsHistory.update(with: QuestionHistory(question: question, questionState: .UNANSWERED))
        }
    }
    var numIncomplete: Int {
        var count = 0
        for hist in questionsHistory {
            if hist.questionState == .UNANSWERED {
                count += 1
            }
        }
        return count
    }
    
    var numCorrect: Int {
        var count = 0
        for hist in questionsHistory {
            if hist.questionState == .CORRECT {
                count += 1
            }
        }
        return count
    }
    
    var numIncorrect: Int {
        var count = 0
        for hist in questionsHistory {
            if hist.questionState == .INCORRECT {
                count += 1
            }
        }
        return count
    }
    
}
