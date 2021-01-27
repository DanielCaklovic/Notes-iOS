//
//  NoteListViewController.swift
//  Notes
//
//  Created by Daniel Caklovic on 25.01.2021..
//

import UIKit
import CoreData

class NoteListViewController: UIViewController {

    @IBOutlet weak var tvNotes: UITableView!
    
    private var notes: [Note] = []
    
    // ideally inject with DI
    var noteRepository = NoteRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }
    
    func setupView() {
        title = "Notes"
        tvNotes.delegate = self
        tvNotes.dataSource = self
        tvNotes.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        tvNotes.layoutMargins = UIEdgeInsets.zero
        tvNotes.separatorInset = UIEdgeInsets.zero
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
    }
    
    @objc func addNewNote() {
        let addNoteVC = EditNoteViewController()
        addNoteVC.delegate = self
        navigationController?.present(addNoteVC, animated: true, completion: nil)
    }
    
    func fetchNotes() {
        notes = noteRepository.fetchNotes()
        UIView.transition(with: tvNotes,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tvNotes.reloadData() })
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.count == 0 {
            self.tvNotes.setEmptyMessage("You don't have any notes. \nAdd a new note using the + button.")
        } else {
            self.tvNotes.restore()
        }
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as? NoteTableViewCell
        else { fatalError("No type found") }
        let note = notes[indexPath.row]
        cell.lblTitle.text = note.title
        cell.lblDate.text = note.date?.toStringDate()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailViewController = NoteDetailViewController(note: notes[indexPath.row])
        navigationController?.pushViewController(noteDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            noteRepository.deleteNote(note: notes[indexPath.row])
            fetchNotes()
        }
    }
}

extension NoteListViewController: EditNoteViewControllerDelegate {
    func didDismiss() {
        fetchNotes()
    }
}
