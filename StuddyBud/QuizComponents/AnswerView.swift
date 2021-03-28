//
//  AnswerView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//
import SwiftUI

struct AnswerView: View {
    
    @EnvironmentObject var quizViewModel: QuizViewModel
    
    var question: Question
    
    // only used if the question type is boolean
    @State var isTrue = Bool.random()
    
    // only used if the question type is FRQ
    @ObservedObject var frqChecker = FRQChecker()
    @State var typedAnswer = ""
    
    @State var correct: Bool?
    @State var selectedAnswer: String?
    
    var body: some View {
        VStack {
            if question.question_type == .BOOL {
                Text(isTrue ? question.correct_answer : question.possible_answers[Int.random(in: 0..<question.possible_answers.count)])
                HStack {
                    Button(action: {
                        if isTrue {
                            correctAnswer()
                        } else {
                            incorrectAnswer()
                        }
                    }, label: {
                        Text("True")
                    })
                    Button(action: {
                        if !isTrue {
                            correctAnswer()
                        } else {
                            incorrectAnswer()
                        }
                    }, label: {
                        Text("False")
                    })
                }
            } else if question.question_type == .FRQ {
                VStack(alignment:.leading) {
                    Text("Type your answer here:").font(.headline).foregroundColor(Color("blue"))
                    
                    TextField("Answer here...", text: $typedAnswer).frame(minHeight: 150).background(Color("lightBlue")).cornerRadius(15.0).overlay(RoundedRectangle(cornerRadius: 15.0).stroke(Color("pink"),lineWidth: 1)).font(.callout)
                    Button(action: { self.frqChecker.check_frq_answer(input: typedAnswer, target: question.correct_answer)}, label: {
                        HStack{
                            Spacer()
                            Text("Check").foregroundColor(Color("pink")).padding(.vertical, 10).padding(.horizontal, 100).background((frqChecker.state == .CORRECT ? Color("green") : Color("yellow")).cornerRadius(15.0))
                            Spacer()
                        }.padding(.vertical)
                    })
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Choose the best answer:").font(.headline).foregroundColor(Color("blue"))
                    VStack {
                        ForEach(question.possible_answers, id: \.self) { choice in
                            Button(action: {
                                withAnimation{
                                    if choice == question.correct_answer {
                                        selectedAnswer = choice
                                        correctAnswer()
                                    }
                                    else {
                                        incorrectAnswer()
                                        selectedAnswer = choice
                                    }
                                }
                            }, label: {
                                if (self.frqChecker.state == .CORRECT && choice == question.correct_answer){
                                    HStack{
                                        Spacer()
                                        Text(choice).foregroundColor(Color(.white)).padding(.vertical, 15).frame(width: 275).padding(.horizontal, 15).background(Color(.green)).cornerRadius(15.0)
                                        Spacer()
                                    }.padding(.vertical, 5)
                                }
                                else if (self.frqChecker.state == .INCORRECT && choice == selectedAnswer){
                                    HStack{
                                        Spacer()
                                        Text(choice).foregroundColor(Color(.white)).padding(.vertical, 15).frame(width: 275).padding(.horizontal, 15).background(Color("pink")).cornerRadius(15.0)
                                        Spacer()
                                    }.padding(.vertical, 5)
                                }
                                else{
                                    HStack{
                                        Spacer()
                                        Text(choice).foregroundColor(Color("pink")).padding(.vertical, 15).frame(width: 275).padding(.horizontal, 15).background(Color("yellow")).cornerRadius(15.0)
                                        Spacer()
                                    }.padding(.vertical, 5)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func correctAnswer() {
        correct = true
        quizViewModel.updateQuestionState(question, state: .CORRECT)
    }
    
    func incorrectAnswer() {
        correct = false
        quizViewModel.updateQuestionState(question, state: .INCORRECT)
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView(
            question: Question(
                question_text: "What is the meaning of life in today's increasingly divided society?",
                question_type: .FRQ,
                correct_answer: "42",
                relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                possible_answers: ["40", "41", "43", "42"])
        ).environmentObject(QuizViewModel(questionSet: QuestionSet(webpage_name: "Demo One",
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
                                                                   ])))
    }
}
