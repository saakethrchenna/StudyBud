//
//  FloatingTabBar.swift
//  StuddyBud
//
//  Created by user175571 on 3/28/21.
//

import SwiftUI

struct FloatingTabBar: View {
    @Binding var selected: Int
    
    var body: some View {
        VStack{
            Spacer()
        HStack{
            Spacer(minLength: 0)
            HStack{
            Button(action: {
                withAnimation{
                    self.selected = 0
                }
                
            }){
                Image(systemName: "homekit").font(.title).foregroundColor(self.selected == 0 ? .black : .gray).padding(.horizontal)
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                withAnimation{
                    self.selected = 1
                }
            }){
                Image(systemName: "bag.badge.plus").font(.title).foregroundColor(self.selected == 1 ? .black : .gray).padding(.horizontal)
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                withAnimation{
                    self.selected = 2
                }                
            }){
                Image(systemName: "person.crop.circle").font(.title).foregroundColor(self.selected == 2 ? .black : .gray).padding(.horizontal)
            }
            }.padding(.vertical, 30).padding(.horizontal, 35).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 15)).padding(22).animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
        }
        }
    }
}


