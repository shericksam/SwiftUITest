//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.network) private var network: ApolloServiceClientProvider
    @ObservedObject private var queryHolder: QueryHolder<AllPokemonQuery>
    @ObservedObject public private(set) var loadingStatePublisher: LoadingStatePublisher = LoadingStatePublisher()
    @State private var loadingState: LoadingState = .loading {
        didSet {
            loadingStatePublisher.loadingState = loadingState
        }
    }
    @State private var result: GraphQLCachingQueryResult<AllPokemonQuery.Data>?
    @State private var errorMessage: String?

    public init() {
        self.queryHolder = QueryHolder(
            query: AllPokemonQuery(offset: 89)
        )
    }
    var body: some View {
        NavigationView {
            ZStack {
                NetworkStatusView()
                if loadingState == .loaded {
                    result?.data
                }
                if loadingState == .loading {
                    LoadingView()
                }
                if loadingState == .error {
                    ErrorView(errorMessage: errorMessage, retryAction: retry)
                }
            }
            .environmentObject(queryHolder)
            .onReceive(queryHolder.$query) { query in
                executeQuery(query)
            }
        }
    }

    private func retry() {
        executeQuery(queryHolder.query)
    }

    func executeQuery(_ query: AllPokemonQuery) {
        loadingState = .loading
        query
            .execute(serviceClient: network) { response in
                switch response {
                case .success(let result):
                    loadingState = .loaded
                    self.result = result
                case .failure(let error):
                    loadingState = .error
                    errorMessage = error.errorDescription
                }
            }
    }
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
