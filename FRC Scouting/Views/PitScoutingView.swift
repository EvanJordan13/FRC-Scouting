//
//  PitScoutingView.swift
//  FRC Scouting
//
//  Created by Evan Jordan on 6/9/22.
//

import SwiftUI

struct PitScoutingView: View {
    
    @ObservedObject var model = AppViewModel()
    private enum FieldToFocus: Int, CaseIterable {
        case matchNumber, teamNumber, allianceMember1, allianceMember2
    }
    @FocusState private var focusedField: FieldToFocus?
    
    @State var selectedAutos = [String]()
    @State var allItems:[String] = [
        "Pilots Left",
        "Pilots Right",
        "One Ball",
        "Two Ball",
        "Three Ball",
        "Four Ball",
        "Five Ball",
        "Six Ball"
    ]
    
    @State var teamNumber = ""
    
    var drivetrains = ["Tank Drive", "Swerve Drive", "Mecanum Drive", "Other"]
    @State var selectedDrivetrain = "Tank Drive"
    
    @State var canAutoHighScore = false
    @State var canAutoLowScore = false
    @State var canTeleopHighScore = false
    @State var canTeleopLowScore = false
    @State var canTaxi = false

    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Robot Specs")) {
                    
                    TextField("Team Number", text: $teamNumber)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .teamNumber)
                    
                    Picker("Drivetrain", selection: $selectedDrivetrain) {
                        ForEach(drivetrains, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Toggle("Can Taxi In Auto", isOn: $canTaxi)
                    
                    Toggle("Can Score High In Auto", isOn: $canAutoHighScore)
                    
                    Toggle("Can Score Low In Auto", isOn: $canAutoLowScore)
                    
                    Toggle("Can Score High In Teleop", isOn: $canTeleopHighScore)
                    
                    Toggle("Can Score High In Teleop", isOn: $canTeleopLowScore)
                    
                    //Multiple Selection for Auto Capabilites
                    NavigationLink(destination: {
                        MultiSelectPickerView(allItems: allItems, selectedItems: $selectedAutos)
                        
                    }, label: {
                        HStack {
                            Text("Auto Capabilites")
                                .foregroundColor(.primary)
                        }
                    })//End Multiple Selection for Auto Capabilites
                    
                }
                
                Button(action: {
                    model.addRobot(teamNumber: teamNumber, drivetrain: selectedDrivetrain, canAutoHigh: canAutoHighScore , canAutoLow: canAutoLowScore, canTeleopHigh: canTeleopHighScore, canTeleopLow: canTeleopLowScore, canTaxi: canTaxi, autos: selectedAutos)
                    
                },
                       
                       label: {
                    Text("Finish Scouting")
                        
                        .foregroundColor(Color.blue)
                })
            }
            .navigationTitle("Pit Scouting")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
    
    struct MultiSelectPickerView: View {
        // The list of items we want to show
        @State var allItems: [String]
        
        // Binding to the selected items we want to track
        @Binding var selectedItems: [String]
        
        var body: some View {
            Form {
                List {
                    ForEach(allItems, id: \.self) { item in
                        Button(action: {
                            withAnimation {
                                if self.selectedItems.contains(item) {
                                    // Previous comment: you may need to adapt this piece
                                    self.selectedItems.removeAll(where: { $0 == item })
                                } else {
                                    self.selectedItems.append(item)
                                }
                            }
                        }) {
                            HStack {
                                Text(item)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                                    .foregroundColor(.blue)
                                
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            
        }
    }
}
