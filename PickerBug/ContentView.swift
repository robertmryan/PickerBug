//
//  ContentView.swift
//  PickerBug
//
//  Created by Robert Ryan on 4/20/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import SwiftUI

struct Object: Identifiable {
    let id = UUID().uuidString
    let string: String
}

class ViewModel: ObservableObject {
    private var counter = 0

    @Published private(set) var objects: [Object] = []
    @Published var segmentedPickerValue: String = ""
    @Published var wheelPickerValue: String = ""

    fileprivate func nextSetOfValues() {
        let newCounter = counter + 3
        objects = (counter..<newCounter).map { value in Object(string: "\(value)") }
        let id = objects.first?.id ?? ""
        segmentedPickerValue = id
        wheelPickerValue = id
        counter = newCounter
    }

    init() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            self.nextSetOfValues()
        }
        timer.fire()
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text("Refresh every 3 seconds").bold()

            VStack {
                Text("Picker - No updates")

                Picker(selection: $viewModel.wheelPickerValue, label: Text("")) {
                    ForEach(viewModel.objects) { object in
                        Text(object.string)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding()

            VStack {
                Text("Segmented Control - OK")

                Picker(selection: $viewModel.segmentedPickerValue, label: Text("")) {
                    ForEach(viewModel.objects) { object in
                        Text(object.string)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding()

            VStack {
                Text("List - OK")

                List {
                    ForEach(viewModel.objects) { object in
                        Text(object.string)
                    }
                }
            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
