//
//  ContentView.swift
//  wordOfTheDay
//
//  Created by William Ng on 10/20/22.
//

import SwiftUI
import CoreData
import Foundation


struct Joke : Codable {
    let value : String
}
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var word : String = ""
    @State private var joke : String = ""
    let headers = [
        "X-RapidAPI-Key": "f2a4d3c53bmsh7987684552cff8ap1d9ce3jsnc1499fb65e40",
        "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
    ]
    var body: some View {
        NavigationView {
            VStack {

                Text(word).padding(100)
                Spacer()
                Button(action : {
                    Task {
                        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")! as URL,
                                                                cachePolicy: .useProtocolCachePolicy,
                                                            timeoutInterval: 10.0)
                        request.httpMethod = "GET"
                        request.allHTTPHeaderFields = headers

                        let session = URLSession.shared
                        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                            if (error != nil) {
                                print(error)
                            } else {
                                let httpResponse = response as? HTTPURLResponse
                                do {
                                    let decodedData =
                                    try JSONDecoder().decode(Word.self, from: data!)
                                    word = decodedData.word ?? ""
                                }
                                catch {
                                    word = "Could not fetch word."
                                }
                               
                                print(httpResponse)
                            }
                        })

                        dataTask.resume()
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

    private func loadData() async throws {
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

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
