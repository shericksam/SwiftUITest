//
//  PokemonListViewModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import CoreData

class PokemonListViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .loading
    @Published var errorMessage: String?
    @Published private var provider: PokemonPaginatedItemProvider
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private var network: ApolloServiceClientProvider
    let repository: PokemonRepositoryImpl

    init(network: ApolloServiceClientProvider = Dependencies.serviceClient) {
        self.network = network
        self.repository = PokemonRepositoryImpl(dataSource: PokemonCoreDataSourceImpl(container: PersistenceController.shared.container))
        self.provider = .init(items: [], size: 20)
    }

    func executeQuery(_ query: AllPokemonQuery) {
        loadingState = .loading
//        saveDataFromAPI(query)
//        query
//            .execute(serviceClient: network) { [weak self] response in
//                switch response {
//                case .success(let result):
//                    self?.loadingState = .loaded
////                    self?.saveItems(items: result.convertToModel())
//                    Task { [weak self] in
//                        guard let self = self else { return }
//                        await self.saveItems(result.data.convertToModel())
//                    }
//                case .failure(let error):
//                    self?.loadingState = .error
//                    self?.errorMessage = error.errorDescription
//                }
//            }
    }

    func retry(_ query: AllPokemonQuery) {
        executeQuery(query)
    }

    private func fetchDataFromAPI(_ query: AllPokemonQuery) async -> [PokemonModel] {
        // Realiza la solicitud a la API y obtén los datos

        // Simulación de datos de ejemplo
        return await withCheckedContinuation { continuation in
            query
                .execute(serviceClient: network) { [weak self] response in
                    switch response {
                    case .success(let result):
                        self?.loadingState = .loaded
                        //                    self?.saveItems(items: result.convertToModel())
//                        Task { [weak self] in
//                            guard let self = self else { return }
//                            await self.saveItems(result.data.convertToModel())
//                        }
                        continuation.resume(returning: result.data.convertToModel())
                    case .failure(let error):
                        self?.loadingState = .error
                        self?.errorMessage = error.errorDescription
                    }
                }
        }
    }

    private func saveDataFromAPI(_ query: AllPokemonQuery) {
        Task {
            let apiData = await fetchDataFromAPI(query)

            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = viewContext
            await privateContext.perform {
                Task {
                    for data in apiData {
                        let result = await self.repository.createPokemon(data)
                        // Asigna los demás atributos según corresponda
                    }

                    do {
                        try await privateContext.save()

                        self.viewContext.performAndWait {
                            do {
                                try self.viewContext.save()
                            } catch {
                                print("Error al guardar en el contexto principal: \(error)")
                            }
                        }
                    } catch {
                        print("Error al guardar en el contexto privado: \(error)")
                    }
                }
            }
        }
    }

    private func saveItems(_ items: [PokemonModel]) {
//        await withTaskGroup(of: Void.self) { group in
//            for item in items {
//                group.addTask { [weak self] in
//                    guard let self = self else { return }
////                    let newItem = Pokemon(context: self.viewContext)
////                    newItem.update(with: item, self.viewContext)
//
//                    print("result before --->\(item.key ?? "")")
//                    let result = await self.repository.createPokemon(item)
//                    print("result--->\(item.key ?? "")", result)
//
//                    do {
//                        try self.viewContext.save()
//                    } catch {
//                        print("Error CoreData: \(error)")
//                    }
//                }
//                await group.waitForAll()
//            }
//        }
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
}
