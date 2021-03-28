//
//  QuizView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct QuizView: View {
    
    @EnvironmentObject var quizViewModel: QuizViewModel
    
    var questionSet: QuestionSet
    
    @State var showSummary = false
    @State var questionNumber = 0
    
    var body: some View {
        ZStack {
            VStack{
            Color("lightBlue").ignoresSafeArea(edges: .top).frame(height: 250)
                Spacer()
            }
            VStack {
                TabView(selection: $questionNumber) {
                    ForEach((0..<questionSet.questions.count), id: \.self) { index in
                        QuestionView(question: questionSet.questions[index])
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            questionNumber = max(0, questionNumber-1)
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.left").font(.title).padding(.trailing, -20)
                            Image(systemName: "chevron.left").font(.title).padding(.trailing, -20)
                            Image(systemName: "chevron.left").font(.title)
                            Text("Previous")
                        }.padding().background(Color("pink")).foregroundColor(.white).cornerRadius(15.0)
                    }).disabled(questionNumber == 0)
                    Button(action: {
                        if questionNumber != questionSet.questions.count-1 {
                            withAnimation {
                                questionNumber = min(questionSet.questions.count-1, questionNumber+1)
                            }
                        }
                        else {
                            showSummary = true
                        }
                    }, label: {
                        if questionNumber != questionSet.questions.count-1 {
                            HStack{
                                Text("Next")
                                Image(systemName: "chevron.right").font(.title)
                                Image(systemName: "chevron.right").font(.title).padding(.leading, -20)
                                Image(systemName: "chevron.right").font(.title).padding(.leading, -20)
                            }.padding().background(Color("blue")).foregroundColor(.white).cornerRadius(15.0)
                        }
                        else {
                            HStack{
                                Text("Finish")
                                Image(systemName: "forward.end").font(.title)
                            }.padding().background(Color("blue")).foregroundColor(.white).cornerRadius(15.0)
                        }
                    })
                }
            }.navigationTitle("Question:")
        }.padding(.bottom, 60).sheet(isPresented: $showSummary, content: {
            SummaryView()
        })
    }
}

struct QuizView_Previews: PreviewProvider {
    
    static var previews: some View {
        QuizView(questionSet: QuestionSet(webpage_name: "Demo One",
                                          webpage_url: "https://youtube.com",
                                          relevant_webpages: [
                                            RelevantWebpage(name: "Apple", url: "https://apple.com"),
                                            RelevantWebpage(name: "Google", url: "https://google.com"),
                                            RelevantWebpage(name: "Amazon", url: "https://amazon.com")
                                          ], questions: [
                                            Question(
                                                question_text: "What is the meaning of life in today's increasingly divided society?",
                                                question_type: .MCQ,
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
                                                question_text: "What is the meaning of life in today's increasingly divided society?",
                                                question_type: .FRQ,
                                                correct_answer: "42",
                                                relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                                possible_answers: ["40", "41", "43", "42"]),
                                          ])).environmentObject(QuizViewModel(questionSet: QuestionSet(webpage_name: "Demo One",
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
                                                                                                            question_text: "What is the meaning of life in today's increasingly divided society?",
                                                                                                            question_type: .FRQ,
                                                                                                            correct_answer: "42",
                                                                                                            relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                                                                                            possible_answers: ["40", "41", "43", "42"]),
                                                                                                       ])))
    }
}
