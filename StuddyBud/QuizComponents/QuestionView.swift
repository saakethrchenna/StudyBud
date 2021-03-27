//
//  QuestionView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct QuestionView: View {
    var question: Question
    
    @State var show_relevant_text: Bool = false
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea(.all)
        VStack {
            ScrollView{
            VStack(alignment: .leading){
               
                Text(question.question_text).fontWeight(.light)
            
                if show_relevant_text {
                    Text("Relevant Text:").font(.title3).fontWeight(.heavy).padding(.top).foregroundColor(Color("blue"))
                    Divider()
                    Text(question.relevant_text).font(.title3).fontWeight(.light).padding(.bottom)
                }
                
                AnswerView(question: question).padding(.top)
                
            }.font(.title2).padding().foregroundColor(.black)
            }.background(Color("lightBlue")).ignoresSafeArea()
            
            Button(action: {
                withAnimation{
                    show_relevant_text.toggle()
                }
            }, label: {
                HStack{
                    Text(show_relevant_text ? "Hide Relevant Text" : "Show Relevant Text")
                }.padding(20).foregroundColor(Color("blue")).font(.headline).frame(maxWidth: 400).background(Color("lightBlue")).cornerRadius(25).padding()
            })
        }.navigationTitle("Question:")
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(
            question: Question(
                question_text: "What is the meaning of life in today's increasingly divided society?",
                question_type: .MCQ,
                correct_answer: "42",
                relevant_text: "Mr. Tubbs is a very cool and interesting individual who needs to be loved and cherished by those who feel his generosity.",
                possible_answers: ["40", "41", "43"])
        )
    }
}

