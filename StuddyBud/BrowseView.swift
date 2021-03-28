//
//  BrowseView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
            VStack {
                TextField("Search...", text: $text).padding(10).padding(.horizontal, 25).background(Color("lightBlue")).cornerRadius(10).onTapGesture{
                    self.isEditing = true
                }.overlay(
                    HStack{
                        Image(systemName: "magnifyingglass").foregroundColor(.white).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill").foregroundColor(.white).padding(.trailing, 10)
                            })
                        }
                    }
                ).foregroundColor(.white)
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("Cancel").padding().background(Color("pink")).cornerRadius(10.0).foregroundColor(.white)
                    }).padding(.trailing, 10).transition(.move(edge: .trailing)).animation(.default)
                }
                
            }
    }
}

struct BrowseView: View {
    var allItems = [QuestionSet.init(
                        webpage_name: "Song Dynasty",
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
                            Question(
                                question_text: "What is the meaning of life in today's increasingly divided society?",
                                question_type: .FRQ,
                                correct_answer: "42",
                                relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                possible_answers: []),
                            Question(
                                question_text: "What is the meaning of life in today's increasingly divided society?",
                                question_type: .FRQ,
                                correct_answer: "42",
                                relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                possible_answers: []),
                        ]), QuestionSet.init(
                            webpage_name: "Alligator Teeth",
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
                                    question_type: .FRQ,
                                    correct_answer: "42",
                                    relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                                    possible_answers: []),
                            ]),QuestionSet.init(
                                webpage_name: "Ducks",
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
                                ])
    ]
    @State var searchText = ""
    
    var body: some View{
        NavigationView{
            VStack{
                SearchBar(text: $searchText).padding()
                ScrollView{
                    ForEach(allItems.filter({searchText.isEmpty ? true: $0.webpage_name.contains(searchText)}), id: \.self){item in
                    BrowseCardView(item: item)
                    }.foregroundColor(.black)
                }
            }.navigationBarTitle("Browse")
        }
    }
}

struct BrowseCardView: View {
    var item: QuestionSet
    
    var body: some View{
        SetCard(questionSet: item, backgroundColor: Color("blue"), foregroundColor: Color("blue"))
    }
}
struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
