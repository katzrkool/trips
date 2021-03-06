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
    
    var template: Category
    @Binding var refreshing: Bool
    
    @State var showDeleteAlert: Bool = false
    
    @State var updatedName: String = ""
    @Binding var selection: SelectionConfig
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $updatedName)
                        .onAppear {
                            if template.name.count > 0 {
                                updatedName = template.name
                            }
                    }
                    //Text((refreshing ? "" : ""))
                }
                Button(action: {
                    showDeleteAlert = true;
                }) {
                    Text("Delete").foregroundColor(.red)
                }.alert(isPresented: $showDeleteAlert, content: {
                    Alert(title: Text("Are you sure you want to delete \(updatedName)?"),
                          message: Text("This cannot be undone."),
                          primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                            presentationMode.wrappedValue.dismiss()
                            selection = SelectionConfig(viewSelectionType: .template, viewSelection: nil)

                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                template.items.forEach {item in
                                    context.delete(item as! NSManagedObject)
                                }
                                context.delete(template)
                            })
                          }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
                })
            }
            .navigationBarItems(trailing:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
            }, label: {
                Text("Close")
            }))
            .navigationBarTitle("Edit Template")
            .onDisappear {
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                if !template.isDeleted && template.name != updatedName && updatedName.count > 0 {
                    template.name = updatedName
                }
                if template.hasChanges {
                    saveContext(context)
                    refreshing.toggle()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditTemplate_Previews: PreviewProvider {
    static var previews: some View {
        Text("AAAAHHH MY COMPUTER CANT DO PREVIEWS, or not very well")
    }
}
