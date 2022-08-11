//
//  IterableCollection.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

enum CollectionPosition {
    case first
    case middle
    case last
}

struct IterableCollection<Element> {
    typealias ElementAndPosition = (value: Element, position: CollectionPosition)
    
    //MARK: - Properties
    
    private let collection: [Element]
    
    private var currentIndex: Int = 0
    
    var first: ElementAndPosition? {
        collection.isEmpty ? nil : (value: collection.first!, position: .first)
    }
    
    var current: ElementAndPosition? {
        switch currentIndex {
            case 0:
                return first
                
            case collection.count - 1:
                return last
                
            default:
                break
        }
        
        return (value: collection[currentIndex], position: .middle)
    }
    
    var last: ElementAndPosition? {
        collection.isEmpty ? nil : (value: collection.last!, position: .first)
    }
    
    //MARK: - LifeCicle
    
    init(collection: [Element]) {
        self.collection = collection
    }
    
    //MARK: - Metods
    
    mutating func next() -> ElementAndPosition? {
        
        currentIndex += 1
        
        if currentIndex == collection.count - 1 {
            return (value: collection[currentIndex], position: .last)
        } else if currentIndex >= collection.count {
            currentIndex = collection.count - 1
            return nil
        }
        
        return (value: collection[currentIndex], position: .middle)
    }
    
    mutating func previous() -> ElementAndPosition? {
        currentIndex -= 1
        
        if currentIndex == 0 {
            return (value: collection[0], position: .first)
        } else if  currentIndex < 0 {
            currentIndex = 0
            return nil
        }
        
        return (value: collection[currentIndex], position: .middle)
    }
    
    mutating func reset() {
        currentIndex = 0
    }
}
