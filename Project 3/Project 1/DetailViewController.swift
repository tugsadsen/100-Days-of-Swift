//
//  DetailViewController.swift
//  Project 1
//
//  Created by Tuğşad Şen on 24.02.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber : Int?
    var totalPictures : Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(selectedPictureNumber!) of \(totalPictures!)"
        
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(shareTapped))
        
        
        if let imageToLoad = selectedImage {
            imageView.image =  UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
            
            guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
                return
            }
            
            guard let imageName = selectedImage else {
                print("No image name found")
                return
            }
            
            let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
             
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }

    
}
