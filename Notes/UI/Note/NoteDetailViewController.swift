//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Daniel Caklovic on 25.01.2021..
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var note: Note
    
    let lblTitle = UILabel()
    let lblText = UILabel()
    let lblDate = UILabel()
    
    // ideally inject with DI
    var noteRepository = NoteRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        title = "Note details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editNode))
        
        setDetails(note: note)
        
        lblTitle.font = .boldSystemFont(ofSize: 32)
        lblText.numberOfLines = 0
        lblText.sizeToFit()
        
        lblDate.font = .systemFont(ofSize: 12)
        
        view.addSubview(lblTitle)
        view.addSubview(lblText)
        view.addSubview(lblDate)
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblText.translatesAutoresizingMaskIntoConstraints = false
        lblDate.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            lblDate.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16),
            lblDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            lblText.topAnchor.constraint(equalTo: lblDate.bottomAnchor, constant: 16),
            lblText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    @objc func editNode() {
        let editNoteVC = EditNoteViewController(note: note)
        editNoteVC.delegate = self
        self.present(editNoteVC, animated: true, completion: nil)
    }
    
    func fetchNote() {
        guard let id = note.id else { return }
        
        if let fetchedNote = noteRepository.fetchNote(id: id) {
            self.note = fetchedNote
            setDetails(note: note)
        }
    }
    
    func setDetails(note: Note) {
        lblTitle.text = note.title
        lblText.text = note.text
        lblDate.text = note.date?.toStringDate()
    }
}

extension NoteDetailViewController: EditNoteViewControllerDelegate {
    func didDismiss() {
        fetchNote()
    }
}
