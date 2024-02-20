//
//  ModelData.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import Foundation

final class ModelData: ObservableObject {
    private static var defaultTasks: [Task] = [
        Task(id: 0, name: "Buy eggs", description: "For breakfast tomorrow", isDone: false, lastModified: Date.now),
        Task(id: 1, name: "Buy milk", description: "By this weekend", isDone: true, lastModified: Date.now),
        Task(id: 2, name: "Take the dog to the vet", description: "This is a very long description just to show that task descriptions are potentially long sentences or even paragraphs. The list on the home screen will show a truncated version of the description but the detail view will show you the entire description.", isDone: false, lastModified: Date.now),
        Task(id: 3, name: "Finish ECE 564 homework", description: "Hmm...", isDone: false, lastModified: Date.now),
        Task(id: 4, name: "Think of more tasks for this demo", description: "", isDone: false, lastModified: Date.now),
        Task(id: 5, name: "Go for a walk", description: "It's good for you!", isDone: false, lastModified: Date.now),
        Task(id: 6, name: "Eat five portions of vegetables a day", description: "It's good for you!", isDone: true, lastModified: Date.now),
        Task(id: 7, name: "Learn SwiftUI", description: "", isDone: true, lastModified: Date.now),
        Task(id: 8, name: "Refactor this codebase", description: "Before students get their hands on it", isDone: false, lastModified: Date.now),
        Task(id: 9, name: "Add guiding comments to this codebase", description: "Before students get their hands on it", isDone: true, lastModified: Date.now)
    ]
    
    @Published var tasks: [Task] = defaultTasks
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
                    .appendingPathComponent("tasks.data")
    }
    
    // Persistence code follows this tutorial: https://developer.apple.com/tutorials/app-dev-training/persisting-data
    static func load(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(defaultTasks))
                    }
                    return
                }
                
                let loadedTasks = try JSONDecoder().decode([Task].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedTasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(tasks: [Task], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(tasks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(tasks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
