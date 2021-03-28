//
//  OnboardingView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var activeSheet: MainViewActiveSheet?
    
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome To StudyBuddy").fontWeight(.heavy).font(.system(size: 40)).frame(alignment:.center).padding(.bottom, 30).foregroundColor(Color("blue"))
            VStack(alignment: .leading){
                NewDetail(image: "heart.fill", imageColor: Color("pink"), title: "More Personalized", description: "AI that tailors questiosn to your learning style.")
                NewDetail(image: "paperclip", imageColor: Color("yellow"), title: "New FRQ", description: "Now test your knowlege with machine designed FRQs.")
                NewDetail(image: "play.rectangle.fill", imageColor: Color("blue"), title: "Unlimted Potential", description: "Enhance your understaning of even the most niche topics.")
            }
            Spacer()
            
            Button(action: {
                withAnimation{
                    self.activeSheet = nil
                }
            }){
                Text("Next").padding(20).foregroundColor(Color("pink")).font(.headline).frame(maxWidth: 400).background(Color("lightBlue")).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color("pink"),lineWidth: 2)).padding()
            }
        }
    }
}

struct NewDetail: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .center){
            Image(systemName: image).font(.system(size: 50)).frame(width: 50).foregroundColor(imageColor).padding()
            
            VStack(alignment: .leading){
                Text(title).bold()
                Text(description).fixedSize(horizontal: false, vertical: true)
            }
        }.frame(width: 340, height: 100)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(activeSheet: .constant(nil)).environmentObject(MainViewModel())
    }
}
