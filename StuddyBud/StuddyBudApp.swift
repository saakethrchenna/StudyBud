//
//  StuddyBudApp.swift
//  StuddyBud
//
//  Created by user175571 on 3/27/21.
//

import SwiftUI

@main
struct StuddyBudApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(MainViewModel()).environmentObject(JobTransmitterAndReceiver())
        }
    }
}
