//
//  NewSetSheet.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

struct NewSetSheetView: View {
    @EnvironmentObject var jtor: JobTransmitterAndReceiver
    @State var entered_url: String = ""
    @Binding var activeSheet: MainViewActiveSheet?
    
    var body: some View {
        ZStack{
            Color("lightBlue").ignoresSafeArea(.all)
        VStack {
            Text("What Do You Want To Learn About Today?").font(.largeTitle).fontWeight(.heavy).padding(.vertical, 50).foregroundColor(.black)
            HStack{
                Image(systemName: "magnifyingglass").font(.title).foregroundColor(Color("blue")).padding(.leading)
                TextField("Enter URL Here", text: $entered_url).textFieldStyle(OvalTextFieldStyle()).foregroundColor(.white)
            }.padding(2).background(Color("yellow")).cornerRadius(15).padding(.horizontal)
            Spacer()
            Button(action: {
                withAnimation{
                    self.jtor.CREATE_JOB_OutboundF(url: entered_url)
                    self.activeSheet = nil
                }
            }, label: {
                HStack{
                    Text("Request").font(.title).fontWeight(.light)
                }.padding(20).padding(.horizontal,50).foregroundColor(.white).font(.headline).background(Color("blue")).cornerRadius(15).padding(.vertical)
            })
        }.padding()
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration.padding(15).background(Color("yellow")).cornerRadius(15)
    }
}

struct NewSetSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NewSetSheetView(activeSheet: .constant(.newSet)).environmentObject(JobTransmitterAndReceiver(preview: true))
    }
}


