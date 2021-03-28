//
//  MainView.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

enum MainViewActiveSheet: Identifiable {
    case onboarding, newSet
    var id: Int {
        hashValue
    }
}

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var questionSetModel: JobTransmitterAndReceiver
    @AppStorage("first_time") var first_time = true
    @AppStorage("client_id") var client_id = ""
    
    @State var activeSheet: MainViewActiveSheet?
    @State var selected = 0
    
    var categories = ["All Sets", "Favorites", "History", "Science", "Popular"]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView{
            
            NavigationView{
                VStack{
                    ScrollView{
                        
                        ForEach(0..<questionSetModel.questionSets.count, id: \.self) { index in
                            if index % 2==0{
                                SetCard(questionSet: questionSetModel.questionSets[index], backgroundColor: Color("blue"), foregroundColor: Color("mediumBlue")).padding(.bottom, -15)
                            }
                            else{
                                SetCard(questionSet: questionSetModel.questionSets[index], backgroundColor: Color("pink"), foregroundColor: Color("mediumPink")).padding(.bottom, -15)
                            }
                        }
                    
                    
                    VStack {
                        Button(action: {
                            activeSheet = .newSet
                        }, label: {
                            HStack{
                                Text("Add New Set").padding(20).font(.headline)
                                Image(systemName: "plus").font(.headline)
                            }.padding(.horizontal).background(Color(.white)).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color("pink"),lineWidth: 2)).padding().foregroundColor(Color("pink"))
                        })
                    }
                        
                    }
                    
                    NavigationLink(
                        destination: SetDetailPage(questionSet: viewModel.selectedSet), isActive: $viewModel.showingSetDetailsView,
                        label: {
                            EmptyView()
                        })
                }.navigationBarTitle("Question Sets").navigationBarItems(trailing: Image("biden").resizable(resizingMode: /*@START_MENU_TOKEN@*/.stretch/*@END_MENU_TOKEN@*/).frame(width: 40, height: 40).clipShape(Circle()).overlay(Circle().stroke(Color("blue"),lineWidth: 2)))
            }.sheet(item: $activeSheet, onDismiss: { self.first_time = false }){ item in
                switch item {
                case .onboarding:
                    OnboardingView(activeSheet: $activeSheet)
                case .newSet:
                    NewSetSheetView(activeSheet: $activeSheet)
                }
                
            }.navigationBarColor(backgroundColor: UIColor(.white), tintColor: UIColor(named: "blue")!).edgesIgnoringSafeArea(.all).onAppear {
                
                if first_time { activeSheet = .onboarding }
                questionSetModel.initializeConnection()
                if client_id == "" {
                    // must request a new id from server
                    questionSetModel.CREATE_CLIENT_ID_OutboundF()
                } else {
                    // tell server the client id
                    questionSetModel.SET_CLIENT_ID_OutBoundF(client_id: client_id)
                }
            }.onReceive(timer) {input in
                questionSetModel.PING_SERVER_OutboundF()
                print("ping")
            }.tabItem { Label("Home", systemImage: "house.fill") }
            BrowseView().tabItem { Label("Browse", systemImage: "bag.badge.plus") }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel()).environmentObject(JobTransmitterAndReceiver(preview: true))
    }
}
