import SwiftUI

struct SetCard: View {
    var questionSet: QuestionSet
    @State var showSafari = false
    @State var urlString = "https://youtube.com"
    @EnvironmentObject var viewModel: MainViewModel
    var backgroundColor: Color
    var foregroundColor: Color
    
    var body: some View {
        ZStack{
            if backgroundColor == Color("blue"){
                HStack{
                    RoundedRectangle(cornerRadius: 15).fill(Color("yellow")).frame(width: 150, height: 400).rotationEffect(.degrees(60)).padding(.leading, -110)
                }
            }
            else {
                HStack{
                    RoundedRectangle(cornerRadius: 15).fill(Color("yellow")).frame(width: 150, height: 400).rotationEffect(.degrees(-60)).padding(.leading, 110)
                }
            }
            RoundedRectangle(cornerRadius: 35).fill(backgroundColor).frame(height: 225).padding(.horizontal)
            Circle().fill(Color("yellow")).frame(height: 20).padding(.top, -95).padding(.leading, -250)
            VStack(alignment:.leading){
            HStack{
                Text(questionSet.webpage_name).font(.title).fontWeight(.medium).foregroundColor(.white).lineLimit(1)
                Spacer()
            }
            Button(action: {
                self.urlString = questionSet.webpage_url
                self.showSafari = true
            }){
                HStack{
                    Text("See Original Page:").font(.body).fontWeight(.light).foregroundColor(.white)
                    Image(systemName: "square.and.arrow.up").font(.caption).foregroundColor(.white).padding(5).background(Circle().strokeBorder(Color.white, lineWidth: 1))
                }
            }.padding(.top, 1)
            
            
            HStack{
                Button(action: {
                    withAnimation{
                        viewModel.selectedSet = questionSet
                        viewModel.showingSetDetailsView = true
                    }
                }, label: {
                    HStack{
                        HStack{
                            Spacer()
                            Text("\(questionSet.questions.count) Terms").font(.title2).fontWeight(.light)
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            Image(systemName: "chevron.right").font(.title)
                            Image(systemName: "chevron.right").font(.title).padding(.leading, -20)
                        }.padding([.top,.bottom] ,5.5).padding(.horizontal,15).background(foregroundColor).padding(.leading, -10).foregroundColor(Color("yellow"))
                    }.foregroundColor(backgroundColor).font(.headline).cornerRadius(15)
                })
            }.background(RoundedRectangle(cornerRadius: 15).fill(Color("yellow"))).padding(.top,35)
        }.padding(.horizontal, 65).padding(.vertical, 35).sheet(isPresented: $showSafari){
            SafariView(url: URL(string: self.urlString)!)
        }
            
        }.padding().padding(.vertical, -60)
    }
}

struct SetCard_Previews: PreviewProvider {
    static var previews: some View {
        SetCard(questionSet: QuestionSet(
                    webpage_name: "Demo One two",
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
                    ]), backgroundColor: Color("blue"), foregroundColor: Color("mediumBlue")).environmentObject(MainViewModel())
    }
}
