//
//  NewPlacesViewController.swift
//  Places
//
//  Created by Алексей Моторин on 05.04.2022.
//

import UIKit

class NewPlacesViewController: UIViewController, UINavigationControllerDelegate {
    
    var newPlace: Places?
    var imageIsChanged = false
    
    private lazy var placeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var imagePlace: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Photo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.backgroundColor = .lightGray
        image.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunc))
        tap.numberOfTapsRequired = 1
        image.addGestureRecognizer(tap)
        
        return image
    }()
    
    
    private lazy var stackObject: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var namePlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 20)
        lable.textColor = .lightGray
        lable.text = "Name"
        return lable
    }()
    
    private lazy var locationPlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 20)
        lable.textColor = .lightGray
        lable.text = "Location"
        return lable
    }()
    
    private lazy var typePlace: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "Apple Sd Gothic Neo", size: 20)
        lable.textColor = .lightGray
        lable.text = "Type"
        return lable
    }()
    
    private lazy var nameTextField: UITextField = {
        let textFeld = UITextField()
        textFeld.translatesAutoresizingMaskIntoConstraints = false
        textFeld.delegate = self
        textFeld.font = UIFont.systemFont(ofSize: 16)
        textFeld.textColor = .black
        textFeld.layer.borderColor = UIColor.lightGray.cgColor
        textFeld.layer.borderWidth = 0.5
        textFeld.layer.cornerRadius = 3
        textFeld.returnKeyType = UIReturnKeyType.done
        textFeld.placeholder = " Place name"
        
        //если текст филд пустой saveButton не активна
        textFeld.addTarget(self, action: #selector(textFeldChangeed), for: .editingChanged) 
        return textFeld
    }()
    
    private lazy var locationTextField: UITextField = {
        let textFeld = UITextField()
        textFeld.translatesAutoresizingMaskIntoConstraints = false
        textFeld.delegate = self
        textFeld.font = UIFont.systemFont(ofSize: 16)
        textFeld.textColor = .black
        textFeld.layer.borderColor = UIColor.lightGray.cgColor
        textFeld.layer.borderWidth = 0.5
        textFeld.layer.cornerRadius = 3
        textFeld.returnKeyType = UIReturnKeyType.done
        textFeld.placeholder = " Place location"
        return textFeld
    }()
    
    private lazy var typeTextField: UITextField = {
        let textFeld = UITextField()
        textFeld.translatesAutoresizingMaskIntoConstraints = false
        textFeld.delegate = self
        textFeld.font = UIFont.systemFont(ofSize: 16)
        textFeld.textColor = .black
        textFeld.layer.borderColor = UIColor.lightGray.cgColor
        textFeld.layer.borderWidth = 0.5
        textFeld.layer.cornerRadius = 3
        textFeld.returnKeyType = UIReturnKeyType.done
        textFeld.placeholder = " Place type"
        return textFeld
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save",
                                     style: .done, target: self,
                                     action: #selector(saveData))
        button.isEnabled = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { nc in
            if let kbdSize = (nc.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let yPosition = kbdSize.height - 140
                self.placeScrollView.contentOffset = CGPoint(x: 0, y: yPosition)
                
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { nc in
                self.placeScrollView.contentOffset = .zero
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "New Place"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(closeVC))
        
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    private func setupView() {
        view.addSubview(placeScrollView)
        
        placeScrollView.addSubview(contentView)
        
        contentView.addSubview(imagePlace)
        contentView.addSubview(stackObject)
        
        stackObject.addArrangedSubview(namePlace)
        stackObject.addArrangedSubview(nameTextField)
        stackObject.addArrangedSubview(locationPlace)
        stackObject.addArrangedSubview(locationTextField)
        stackObject.addArrangedSubview(typePlace)
        stackObject.addArrangedSubview(typeTextField)
        
        NSLayoutConstraint.activate([
            
            placeScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            placeScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            placeScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            placeScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: placeScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: placeScrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: placeScrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: placeScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: placeScrollView.heightAnchor),
            
            imagePlace.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            imagePlace.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagePlace.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagePlace.heightAnchor.constraint(equalToConstant: 250),
            
            stackObject.topAnchor.constraint(equalTo: imagePlace.bottomAnchor, constant: 9),
            stackObject.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackObject.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackObject.heightAnchor.constraint(equalToConstant: 250)
            
        ])
        
    }
    
    // MARK: left and right navigationItem button
    @objc private func closeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveData() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = imagePlace.image
        } else {
            image = UIImage(named: "FoodIcon")
        }
        
        newPlace = Places(restaurantImage: nil,
                          namePlace: nameTextField.text ?? "Error",
                          locationPlace: locationTextField.text,
                          typePlace: typeTextField.text,
                          image: image)
        
        MyPlaces.array.append(newPlace ?? Places(namePlace: "Error"))
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: tap image
    @objc private func tapFunc() {
        
        // создали две иконки
        let cameraIcon = UIImage(systemName: "camera")
        let photoIcon = UIImage(systemName: "photo")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        // добавили иконку и поставили текст слева
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}


// MARK: Work with TextField
extension NewPlacesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    //  если текст филд пустой saveButton не активна
    @objc private func textFeldChangeed() {
        if nameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


// MARK: Work with Image

extension NewPlacesViewController: UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // позволяет редактировать выбранное изображение
            imagePicker.sourceType = source // определяем тип источника для выбранного изображения
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePlace.image = info[.editedImage] as? UIImage
        imagePlace.contentMode = .scaleAspectFill
        imagePlace.clipsToBounds = true
        
        imageIsChanged = true
        dismiss(animated: true)
    }
    
}
