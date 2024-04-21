//
//  ContentView.swift
//  Frameworks-Maps-and-stuff
//
//  Created by TA on 3/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            MapsView()
                .tabItem{
                    Label("Maps", systemImage: "map")
                }
            GeolocationView()
                .tabItem{
                    Label("Geolocation", systemImage: "mappin.and.ellipse")
                }
            CalendarView()
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }
            ContactsView()
                .tabItem{
                    Label("Contacts", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
