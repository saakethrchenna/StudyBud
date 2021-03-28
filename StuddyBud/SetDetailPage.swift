import SwiftUI

enum SetDetailPageActiveSheet: Identifiable {
    case safari, share
    var id: Int {
        hashValue
    }
}

struct SetDetailPage: View {
    var questionSet: QuestionSet
    @State var showSafari = false
    @State var urlString = "https://apple.com"
    @State private var activeSheet: SetDetailPageActiveSheet?
    
    var body: some View {
        VStack(alignment: .leading){
           
                Text("Other Relevant Webpages:").font(.title2).fontWeight(.bold).foregroundColor(.gray)
               
                    ForEach(questionSet.relevant_webpages, id: \.id){ site in
                        Button(action: {
                            self.urlString = site.url
                            self.activeSheet = .safari
                        }){
                            Text(site.name).font(.title3).fontWeight(.light).foregroundColor(Color("pink")).underline().lineLimit(1)
                        }
                    }
            
            
            HStack{
                Text("All Questions:").font(.title2).fontWeight(.bold).foregroundColor(.gray)
                Spacer()
            }.padding(.top)
            Divider()
            
            TabView{
                ForEach(questionSet.questions, id: \.id){ question in
                    questionCard(question: question).padding()
                }
            }.tabViewStyle(PageTabViewStyle())
            
            HStack{
                Button(action: {
                    self.activeSheet = .share
                }, label: {
                    HStack{
                        Image(systemName: "square.and.arrow.up").font(.title2)
                    }.padding().foregroundColor(.white).font(.headline).background(Color("pink")).cornerRadius(15)
                })
                
                NavigationLink(
                    destination: QuizView(questionSet: questionSet).environmentObject(QuizViewModel(questionSet: questionSet)).navigationTitle("Questions"),
                    label: {
                        HStack{
                            Text("Test Your Knowledge").font(.headline)
                            Image(systemName: "chevron.right").font(.title)
                            Image(systemName: "chevron.right").font(.title).padding(.leading, -20)
                            Image(systemName: "chevron.right").font(.title).padding(.leading, -20)
                        }.padding().foregroundColor(.white).font(.headline).background(Color( "blue")).cornerRadius(15)
                    })
            }
            
        }.padding().sheet(item: $activeSheet) {item in
            switch item {
            case .safari:
                SafariView(url: URL(string: self.urlString)!)
            case .share:
                ShareSheetView(activityItems: [questionSet.webpage_url])
            }
        }
        .navigationTitle(questionSet.webpage_name)
    }
}

struct questionCard: View {
    var question: Question
    @State var showAnswer = false
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Text("Relevant Text:").font(.headline).fontWeight(.heavy)
                Spacer()
            }
            Text(question.relevant_text).font(.caption).fontWeight(.light)
            Divider()
            HStack{
                Text("Question:").font(.headline).fontWeight(.heavy)
                Spacer()
            }
            Text(question.question_text).fontWeight(.light)
            Divider()
            HStack{
                Text("Correct Answer:").font(.headline).fontWeight(.heavy)
                Spacer()
            }
            VStack(alignment: .leading){
                if !showAnswer{
                    Text(question.correct_answer).fontWeight(.light).blur(radius: 2.5)
                }
                else {
                    Text(question.correct_answer).fontWeight(.light)
                }
                
                if question.question_type == .FRQ {
                    Text("*This question is an FRQ, shown above is just a suggested answer").font(.caption2)
                }
            }.onTapGesture {
                withAnimation{
                    showAnswer.toggle()
                }
            }
        }.padding().frame(maxHeight:400).background(Color("lightBlue")).cornerRadius(10.0)
    }
}
struct SetDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        SetDetailPage(questionSet: QuestionSet(
                        webpage_name: "Demo One",
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
                        ]))
    }
}
