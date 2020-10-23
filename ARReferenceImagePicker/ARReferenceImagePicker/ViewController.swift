//
//  ViewController.swift
//  ARReferenceImagePicker
//
//  Created by James Daigler on 10/15/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var referenceImages:Set<ARReferenceImage> = Set<ARReferenceImage>();
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @IBAction func addTrackingImage(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func closePicker() {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }

        //Turn the UIImage into a CGImage so we can get the core image data
        guard let cgImage = image.cgImage else { return }

        //Create the arreferenceimage
        let arReferenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(cgImage.width))
        arReferenceImage.name = "arReferenceImage"
        referenceImages.insert(arReferenceImage)
        
        //reconfigure the scene and add the reference image to the configurations detected images
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        DispatchQueue.main.async {
            if anchor is ARImageAnchor {
                print("Anchor located at x:\(anchor.transform.columns.3.x) y:\(anchor.transform.columns.3.y) z:\(anchor.transform.columns.3.z)")
            }
        }
        
        return node

    }
   
}
