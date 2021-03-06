//
//  AddItem.swift
//  Trips
//
//  Created by Lucas Kellar on 2019-10-08.
//  Copyright © 2019 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct AddItem: View {
    var categories: [Category]
    var selectCategory: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.managedObjectContext) var context
        
    @State var title: String = ""
    @State var selectedCategory: Int = 0
    
    @State var quantity: Int = 1
    
    @Binding var refreshing: Bool
    @Binding var selection: SelectionConfig
    var accent: Color
    
    init(categories: [Category], selectCategory: Bool, refreshing: Binding<Bool>, accent: Color, selection: Binding<SelectionConfig>) {
        if (categories.count > 1) {
            self.categories = categories.sorted { first, second in
                return first.index < second.index
            }
        } else {
            self.categories = categories
        }
        self.selectCategory = selectCategory
        _refreshing = refreshing
        _selection = selection
        self.accent = accent
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item Name", text: $title)
                    
                    IntegratedStepper(quantity: $quantity, upperLimit: 50, lowerLimit: 1)
                    
                }
                if selectCategory {
                    Section {
                        Picker(selection: $selectedCategory, label: Text("Category"),
                               content: {
                                if categories.count > 0 {
                                    ForEach(0 ..< categories.count, id:\.self) { index in
                                        Text(categories[index].name).tag(index)
                                    }
                                } else {
                                    Text("No Categories for this Trip. Please create a category before adding an Item.")
                                }
                        })
                    }
                }
                Section {
                    Button(action: {
                        let localTitle = title
                        title = ""
                        saveItem(title: localTitle, quantity: quantity)
                        
                        quantity = 1
                    }) {
                        Text("Add Another")
                    }.disabled(checkForSave() ? false : true)
                }
                Section(footer: Text(selectCategory && categories.count == 0 ? "No Categories in Trip. Please create a Category before adding an Item." : "")) {
                    Button(action: {
                        saveItem(title: title, quantity: quantity)
                        selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }.disabled(checkForSave() ? false : true)
                }
            }.navigationBarTitle("Add Item")
            .navigationBarItems(trailing:
                Button(action: {
                    selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }.accentColor(accent)
            .onDisappear(perform: {
                refreshing.toggle()
                selection = SelectionConfig(viewSelectionType: selection.viewSelectionType, viewSelection: selection.viewSelection, secondaryViewSelectionType: nil, secondaryViewSelection: nil)
        }).navigationViewStyle(StackNavigationViewStyle())
    }
    
    func checkForSave() -> Bool {
        if title.count == 0 {
            return false
        }
        if selectCategory && categories.count == 0 {
            return false
        }
        return true
    }
    
    func saveItem(title: String, quantity: Int) {
        do {
            let category = categories[selectedCategory]
            let item = Item(context: context)
            
            item.name = title
            item.index = try Item.generateItemIndex(category: category, context: context)
            category.addToItems(item)
            
            if (quantity > 1) {
                item.completedCount = 0
                item.totalCount = quantity
            }
            
            try context.save()
        } catch {
            print(error)
        }
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("Rhis is rocky")
    }
}
