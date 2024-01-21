//
//  ViewController.swift
//  SaveTextField
//
//  Created by azinavi on 21/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    var inputTextField = UITextField()
    var enteredTextLabel = UILabel()
    var succesTitleLabel = UILabel()
    var saveButton = UIButton()
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSuperView()
        setupInputTextField()
        setupEnteredTextLabel()
        setupSaveButton()
        setupKeyboardSettings()
        
    }
    
    func setupInputTextField() {
        inputTextField.delegate = self
        inputTextField.frame = CGRect(x: view.center.x - screenWidth / 2 + 20, y: view.center.y + 120, width: screenWidth - 40, height: 50)
        inputTextField.placeholder = "Введите текст"
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите текст", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue]
        )
        inputTextField.textAlignment = .center
        enteredTextLabel.font = UIFont.systemFont(ofSize: 20)
        inputTextField.textColor = .blue
        inputTextField.layer.cornerRadius = 10
        inputTextField.layer.borderWidth = 1.3
        inputTextField.layer.borderColor = UIColor.blue.cgColor
        inputTextField.backgroundColor = .white
        
        view.addSubview(inputTextField)
    }
    
    func setupEnteredTextLabel() {
        enteredTextLabel.frame = CGRect(x: view.center.x - screenWidth / 2 + 20, y: 80, width: screenWidth - 40, height: 50)
        enteredTextLabel.textAlignment = .center
        enteredTextLabel.textColor = .systemBlue
        enteredTextLabel.font = UIFont.systemFont(ofSize: 30)
        enteredTextLabel.numberOfLines = 0
        enteredTextLabel.adjustsFontSizeToFitWidth = true
        enteredTextLabel.minimumScaleFactor = 0.1
        view.addSubview(enteredTextLabel)
    }
    
    func setupSuccesTitleLabel() {
        succesTitleLabel.frame = CGRect(x: view.center.x - screenWidth / 2 + 20, y: 30, width: screenWidth - 40, height: 50)
        succesTitleLabel.text = "Введенный текст:"
        succesTitleLabel.textColor = .white
        succesTitleLabel.textAlignment = .center
        succesTitleLabel.font = UIFont.systemFont(ofSize: 20)
        
        
        view.addSubview(succesTitleLabel)
    }
    
    func setupSuperView() {
        view.backgroundColor = .black
    }
    
    func setupSaveButton() {
        saveButton.frame = CGRect(x: inputTextField.center.x - 65, y: inputTextField.center.y + 40, width: 130, height: 35)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.layer.cornerRadius = 15
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.addTarget(self, action: #selector(saveText), for: .touchUpInside)
        
        
        view.addSubview(saveButton)
    }
    @objc func saveText() {
        enteredTextLabel.text = inputTextField.text
        
        if (inputTextField.text!.count <= 0) {
            shakeTextField()
            inputTextField.layer.borderColor = UIColor.red.cgColor
            inputTextField.layer.borderWidth = 1.5
            enteredTextLabel.text = "Введите текст!"
            enteredTextLabel.textColor = .red
            enteredTextLabel.font = UIFont.systemFont(ofSize: 20)
            succesTitleLabel.removeFromSuperview()
        } else {
            setupSuccesTitleLabel()
            inputTextField.layer.borderColor = UIColor.green.cgColor
            enteredTextLabel.text = inputTextField.text
            enteredTextLabel.textColor = .systemBlue
            inputTextField.text = .none
        }
    }
    
    
    func shakeTextField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: inputTextField.center.x - 10, y: inputTextField.center.y)
        let toPoint = CGPoint(x: inputTextField.center.x + 10, y: inputTextField.center.y)
        
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        inputTextField.layer.add(animation, forKey: "position")
    }
    
    func setupKeyboardSettings() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
            NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (saveButton.frame.origin.y + saveButton.frame.height)
            self.view.frame.origin.y -= keyboardHeight - bottomSpace + 20
        }
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        inputTextField.text = .none
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == inputTextField) {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text!.count <= 0) {
            shakeTextField()
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.5
            enteredTextLabel.text = "Введите текст!"
            enteredTextLabel.textColor = .red
            enteredTextLabel.font = UIFont.systemFont(ofSize: 20)
            succesTitleLabel.removeFromSuperview()
        } else {
            setupSuccesTitleLabel()
            textField.layer.borderColor = UIColor.green.cgColor
            enteredTextLabel.text = textField.text
            enteredTextLabel.textColor = .systemBlue
        }
    }
}
