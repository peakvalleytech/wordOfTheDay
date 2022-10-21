//
//  ContentView.swift
//  wordOfTheDay
//
//  Created by William Ng on 10/20/22.
//

import SwiftUI
import CoreData

struct Joke : Codeable {
    let text : String
}
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var word : String = ""
    @State private var joke : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("word").padding(100)
                Spacer()
                Button(action : {
                    Task {
                        let url = "https://api.chucknorris.io/jokes/random"
                        let (data, _) =
                        try await URLSession
                            .shared
                            .data(
                                from : URL(string : url)!
                            )
                        let decodedResponse =
                        try? JSONDecoder()
                            .decode(Joke.self, from : data)
                        joke = decodedResponse?.value ?? ""
                    }
                }
                ) {
                    Text("Fetch Word")
                }.padding(100)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
    
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
