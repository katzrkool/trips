//
//  IconPicker.swift
//  Trips
//
//  Created by Lucas Kellar on 2020-06-14.
//  Copyright © 2020 Lucas Kellar. All rights reserved.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selectedIcon: String

    var iconSize: CGFloat
    
    init(selectedIcon: Binding<String>, width: CGFloat) {
        iconSize = width * 0.07
        _selectedIcon = selectedIcon
    }
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 50))]

    var body: some View {
        LazyVGrid(columns: gridItemLayout) {
            IconPickerCircle(icon: "house.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "airplane", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "briefcase.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "map.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "gamecontroller.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "gift.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "studentdesk", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "cart.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "car.fill", selectedColor: $selectedIcon, iconSize: iconSize)
            IconPickerCircle(icon: "person.2.fill", selectedColor: $selectedIcon, iconSize: iconSize)
        }
    }
}


struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("Not even going to try here")
    }
}
