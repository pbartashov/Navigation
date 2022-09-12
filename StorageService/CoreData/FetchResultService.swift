//
//  FetchResultService.swift
//  StorageService
//
//  Created by Павел Барташов on 09.09.2022.
//

import CoreData

public enum FetchResultServiceState {
    case willChangeContent
    case insert(at: IndexPath)
    case update(at: IndexPath)
    case move(from: IndexPath, to: IndexPath)
    case delete(at: IndexPath)
    case didChangeContent
}

final class FetchResultService: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    var stateChanged: ((FetchResultServiceState) -> Void)?
    private var state: FetchResultServiceState? {
        didSet {
            if let state = state {
                stateChanged?(state)
            }
        }
    }
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let context: NSManagedObjectContext

    var results: [NSFetchRequestResult]? {
        fetchedResultsController?.fetchedObjects
    }


    // MARK: - LifeCicle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Metods

    func startFetching(with request: NSFetchRequest<NSFetchRequestResult>) throws {
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        controller.delegate = self

        do {
            try controller.performFetch()
        } catch {
            throw DatabaseError.error(desription: "Failed to fetch entities: \(error)")
        }

        fetchedResultsController = controller
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        state = .willChangeContent
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    state = .insert(at: indexPath)
                }

            case .update:
                if let indexPath = indexPath {
                    state = .update(at: indexPath)
                }

            case .move:
                if let indexPath = indexPath,
                   let newIndexPath = newIndexPath {
                    state = .move(from: indexPath, to: newIndexPath)
                }

            case .delete:
                if let indexPath = indexPath {
                    state = .delete(at: indexPath)
                }
                
            @unknown default:
                break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        state = .didChangeContent
    }
}
