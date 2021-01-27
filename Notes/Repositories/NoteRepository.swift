//
//  NoteRepository.swift
//  Notes
//
//  Created by Daniel Caklovic on 26.01.2021..
//

import UIKit
import CoreData

//TODO: Handle success or fail statuses on UI
//TODO: throw error and display in alert view
protocol NoteRepositoryProtocol: class {
    func fetchNotes() -> [Note]
    func fetchNote(id: UUID) -> Note?
    func createNote(title: String, text: String) throws
    func updateNote(note: Note, title: String, text: String) throws
    func deleteNote(note: Note)
}

class NoteRepository: NoteRepositoryProtocol {
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteNote(note: Note) {
        context.delete(note)
    }
    
    func createNote(title: String, text: String) throws {
        do {
            let noteEntity = Note(context: context)
            noteEntity.date = Date()
            noteEntity.id = UUID()
            noteEntity.text = text
            noteEntity.title = title
            
            try context.save()
            
        } catch (let error){
            print ("save task failed", error)
            throw error
        }
    }
    
    func updateNote(note: Note, title: String, text: String) throws {
        do {
            note.setValue(text, forKey: "text")
            note.setValue(title, forKey: "title")
            note.setValue(Date(), forKey: "date")
            
            try context.save()
        } catch (let error) {
            print ("update task failed", error)
            throw error
        }
    }
    
    func fetchNotes() -> [Note] {
        do {
            let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            return try context.fetch(fetchRequest)
        } catch {
            print ("fetch task failed", error)
            return []
        }
    }
    
    func fetchNote(id: UUID) -> Note? {
        do {
            let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
            let fetchedResults = try context.fetch(fetchRequest)
            guard let result = fetchedResults.first else { return nil }
            return result
        } catch {
            print ("fetch task failed", error)
            return nil
        }
    }
}
