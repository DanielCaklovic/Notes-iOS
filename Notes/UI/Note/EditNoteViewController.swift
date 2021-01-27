//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Daniel Caklovic on 25.01.2021..
//

import UIKit

protocol EditNoteViewControllerDelegate: class {
    func didDismiss()
}

class EditNoteViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var textViewText: UITextView!
    
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblTextError: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!

    // ideally inject with DI
    var noteRepository = NoteRepository()
    
    weak var delegate: EditNoteViewControllerDelegate?
    
    // Edit mode if note exists
    var note: Note?
    
    init(note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        note == nil ? addNewNote() : updateNote()
    }
    
    func addNewNote() {
        if isFormValid() {
            guard let title = tfTitle.text else { return }
            do {
                try noteRepository.createNote(title: title, text: textViewText.text)
                showConfirmationAlert()
            } catch(let error) {
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func updateNote() {
        if isFormValid() {
            guard let note = note, let title = tfTitle.text else { return }
            do {
                try noteRepository.updateNote(note: note, title: title, text: textViewText.text)
                showConfirmationAlert()
            } catch(let error) {
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func isTitleValid() -> Bool {
        return !(tfTitle.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false)
    }
    
    func isTextValid() -> Bool {
        return !textViewText.text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func isFormValid() -> Bool {
        return isTextValid() && isTitleValid()
    }
    
    func showConfirmationAlert() {
        let alert = UIAlertController(title: "Success", message: "Your note has been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: {
                self.delegate?.didDismiss()
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupView() {
        textViewText.clipsToBounds = true;
        textViewText.layer.cornerRadius = 10.0;
        
        lblTitleError.isHidden = true
        lblTextError.isHidden = true
        
        tfTitle.delegate = self
        textViewText.delegate = self
        
        btnSave.setTitle("Save", for: [])
        btnSave.isEnabled = false
        
        if let note = note {
            lblTitle.text = "Edit note"
            tfTitle.text = note.title
            textViewText.text = note.text
        }
    }
}

extension EditNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblTextError.isHidden = isTextValid()
        btnSave.isEnabled = isTextValid() && isTitleValid()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let text = textView.text as NSString? {
            let newLength = text.length + text.length - range.length
            return newLength <= 1000
        }
        return true
    }
}

extension EditNoteViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfTitle {
            if let text = textField.text as NSString? {
                lblTitleError.isHidden = isTitleValid()
                btnSave.isEnabled = isTextValid() && isTitleValid()
                
                let newLength = text.length + string.count - range.length
                return newLength <= 20
            }
        }
        return true
    }
}
