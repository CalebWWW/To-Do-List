//
//  ImageViewController.swift
//  to-do2
//
//  Created by Nathan Freeman on 4/4/24.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageStored: UIImageView!
    
    var desiredImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStored.image = desiredImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
