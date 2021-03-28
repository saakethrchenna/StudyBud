//
//  SummaryView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text(String(format: "%.0f%% Correct", Float(quizViewModel.numCorrect)/Float(max(quizViewModel.questionSet.questions.count,1)))).font(.largeTitle).fontWeight(.heavy)
                VStack {
                    Text("Incorrect or Unanswered Questions").font(.headline).fontWeight(.light)
//                    ForEach(quizViewModel.questionsHistory, id: \.0.id) { (question, state) in
//                        if history.questionState == .INCORRECT || history.questionState == .UNANSWERED {
//                            questionCard(question: history.question, showAnswer: true).padding()
//                        }
//                    }
                }
            }.padding()
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView().environmentObject(QuizViewModel(questionSet: QuestionSet(webpage_name: "Demo One",
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
                                                                                       question_text: "What is the meaning of life in todday's increasingly divided society?",
                                                                                       question_type: .MCQ,
                                                                                       correct_answer: "42",
                                                                                       relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                                                                       possible_answers: ["40", "41", "43"]),
                                                                                   Question(
                                                                                       question_text: "What is the meaning of life in today's increasingly dsivided society?",
                                                                                       question_type: .FRQ,
                                                                                       correct_answer: "42",
                                                                                       relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                                                                       possible_answers: []),
                                                                               ])))
    }
}

