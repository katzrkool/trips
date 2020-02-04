//
//  EditTemplate.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-01-28.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI
import CoreData

struct EditTemplate: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var template: Pack
    
    @State var updatedName: String = ""
   
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $updatedName)
                        .onAppear {
                            if self.template.name.count > 0 {
                                self.updatedName = self.template.name
                            }
                    }
                    //Text((self.refreshing ? "" : ""))
                }
            }
            .navigationBarTitle("Edit Item")
            .navigationBarItems(trailing:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Close")
            }))
        }.onDisappear {
            self.template.name = self.updatedName
            saveContext(self.context)
        }
    }
}

struct EditTemplate_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}