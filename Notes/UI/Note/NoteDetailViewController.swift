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
    let scrollView = UIScrollView()
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 100, height: 200)
    }
    
    func setupView() {
        title = "Note details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editNode))
        
        setDetails(note: note)
        
        lblTitle.font = .boldSystemFont(ofSize: 32)
        lblText.numberOfLines = 0
        lblText.sizeToFit()
        
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        
        view.addSubview(lblTitle)
        view.addSubview(scrollView)
        scrollView.addSubview(lblText)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            lblText.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16),
            lblText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            scrollView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16)
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
    }
}

extension NoteDetailViewController: EditNoteViewControllerDelegate {
    func didDismiss() {
        fetchNote()
    }
}
