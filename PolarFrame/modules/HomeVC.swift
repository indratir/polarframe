//
//  HomeVC.swift
//  PolarFrame
//
//  Created by Indra Tirta Nugraha on 03/10/20.
//  Copyright © 2020 Indra Tirta Nugraha. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var btnSelectPhoto: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSquare: UIButton!
    @IBOutlet weak var btnStory: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    
    lazy var picker = UIImagePickerController()
    var selectedRatio: ImageRatio = .square
    var isImagePicked = false {
        didSet {
            btnSelectPhoto.isHidden = isImagePicked
            
            btnSave.isHidden = !isImagePicked
            btnReset.isHidden = !isImagePicked
            btnSquare.isHidden = !isImagePicked
            btnStory.isHidden = !isImagePicked
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
    }

    @IBAction func onClickSelectPhoto(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func onClickSave(_ sender: UIButton) {
        if selectedRatio == .square {
            guard let image = Square.create(selectedImage: imagePreview.image, size: CGSize(width: 1242, height: 1242)) else {
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        } else if selectedRatio == .story {
            guard let image = Story.create(selectedImage: imagePreview.image, size: CGSize(width: 1242, height: 2208)) else {
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: nil, message: "Successfully saved to your gallery!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @IBAction func onReset(_ sender: UIButton) {
        isImagePicked = false
        imagePreview.image =  nil
    }
    
    @IBAction func onClickSquare(_ sender: UIButton) {
        btnSquare.backgroundColor = .link
        btnSquare.setTitleColor(.white, for: .normal)
        
        btnStory.backgroundColor = .systemGroupedBackground
        btnStory.setTitleColor(.black, for: .normal)
        
        selectedRatio = .square
    }
    
    @IBAction func onClickStory(_ sender: UIButton) {
        btnStory.backgroundColor = .link
        btnStory.setTitleColor(.white, for: .normal)
        
        btnSquare.backgroundColor = .systemGroupedBackground
        btnSquare.setTitleColor(.black, for: .normal)
        
        selectedRatio = .story
    }
    
    func openGallery() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePreview.image = chosenImage
            isImagePicked = true
        }
        
        dismiss(animated: true)
    }
}

enum ImageRatio {
    case square
    case story
}
