//
//  ContentView.swift
//  Rock Paper Scissors (Final App)
//
//  Created by Devan Myers on 11/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var playerChoice = "❔"
    @State private var computerChoice = "❔"
    @State private var resultMessage = "Choose your move!"
    @State private var showResult = false
    @State private var isPlayingAgainstComputer = true
    @State private var friendChoice = "❔"
    @State private var bothPlayersReady = false
    
    // possible choices
    let choices = ["✊", "✋", "✌️"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Rock Paper Scissors")
                .font(.largeTitle)
                .bold()
            
            // picker for game mode
            Picker("Game Mode", selection: $isPlayingAgainstComputer) {
                Text("Computer").tag(true)
                Text("Friend").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // player and opponent Views
            HStack {
                VStack {
                    Text("You")
                        .font(.title2)
                    // show player choice if both players are ready or its computer mode
                    //https://www.programiz.com/swift-programming/operators
                    //https://www.programiz.com/swift-programming/ternary-conditional-operator
                    Text(shouldShowPlayerChoice ? playerChoice : "❔")
                        .font(.system(size: 80))
                }
                Spacer()
                VStack {
                    if isPlayingAgainstComputer {
                        Text("Computer")
                            .font(.title2)
                        Text(computerChoice)
                            .font(.system(size: 80))
                    } else {
                        Text("Friend")
                            .font(.title2)
                        // show friendss choice only if both players are ready
                        //https://www.programiz.com/swift-programming/operators
                        //https://www.programiz.com/swift-programming/ternary-conditional-operator
                        Text(bothPlayersReady ? friendChoice : "❔")
                            .font(.system(size: 80))
                    }
                }
            }
            .padding(.horizontal)
            
            // result message
            Text(resultMessage)
                .font(.title3)
            
            // buttons for choices
            HStack(spacing: 20) {
                ForEach(choices, id: \.self) { choice in
                    Button(action: {
                        makeMove(playerMove: choice)
                    }) {
                        Text(choice)
                            .font(.system(size: 60))
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showResult) {
            Alert(title: Text("Game Over"), message: Text(resultMessage), dismissButton: .default(Text("Play Again"), action: resetGame))
        }
    }
    
    // control when to show player choice
    private var shouldShowPlayerChoice: Bool {
        return isPlayingAgainstComputer || bothPlayersReady
    }
    
    // function to handle move selection
    private func makeMove(playerMove: String) {
        if isPlayingAgainstComputer {
            playerChoice = playerMove
            //https://www.programiz.com/swift-programming/operators
            //https://www.programiz.com/swift-programming/optionals#nil-coalescing
            computerChoice = choices.randomElement() ?? "❔"
            bothPlayersReady = true
            determineWinner()
        } else {
            if playerChoice == "❔" {
                playerChoice = playerMove
                resultMessage = "Waiting for friend to choose..."
            } else {
                friendChoice = playerMove
                bothPlayersReady = true
                determineWinner()
            }
        }
    }
    
    // function to determine the winner
    private func determineWinner() {
        //https://www.programiz.com/swift-programming/operators
        //https://www.programiz.com/swift-programming/ternary-conditional-operator

        let opponentMove = isPlayingAgainstComputer ? computerChoice : friendChoice
        
        if playerChoice == opponentMove {
            resultMessage = "It's a draw!"
        } else if (playerChoice == "✊" && opponentMove == "✌️") ||
                  (playerChoice == "✋" && opponentMove == "✊") ||
                  (playerChoice == "✌️" && opponentMove == "✋") {
            resultMessage = "You Win!"
        } else {
            resultMessage = "You Lose!"
        }
        
        // show result after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showResult = true
        }
    }
    
    // function to reset the game
    private func resetGame() {
        playerChoice = "❔"
        computerChoice = "❔"
        friendChoice = "❔"
        bothPlayersReady = false
        resultMessage = "Choose your move!"
    }
}

#Preview {
    ContentView()
}

