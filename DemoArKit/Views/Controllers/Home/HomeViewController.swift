//
//  HomeViewController.swift
//  DemoArKit
//
//  Created by Chinh Pham N. on 6/12/19.
//  Copyright © 2019 Chinh Pham N. All rights reserved.
//

import UIKit
import ARKit
import SwifterSwift

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var footerViewBottomConstraint: NSLayoutConstraint!

    let configuration = ARWorldTrackingConfiguration()
    
    // MARK: - View Life Cycle

    deinit { removeNotificationsObserver() }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configObServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - Private Functions & IBActions

extension HomeViewController {

    private func configUI() {
        configureLighting()
        urlTextField.setLeftPaddingPoints(Config.paddingTextField)
        urlTextField.setRightPaddingPoints(Config.paddingTextField)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addVideoNode(_:)))
        sceneView.addGestureRecognizer(gesture)
    }

    private func configObServer() {
        addNotificationObserver(
            name: UIResponder.keyboardWillShowNotification,
            selector: #selector(keyboardWillShow(notification:)))

        addNotificationObserver(
            name: UIResponder.keyboardWillHideNotification,
            selector: #selector(keyboardWillHide(notification:)))
    }

    private func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }

    @objc private func addVideoNode(_ recognizer: UIGestureRecognizer) {
        urlTextField.endEditing(true)
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard
            let hitTestResult = hitTestResults.first,
            let string = urlTextField.text,
            let videoURL = URL(string: string)
            else { return }

        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z

        let videoNode = SKVideoNode(url: videoURL)
        videoNode.play()
        // set the size (just a rough one will do)
        let videoScene = SKScene(size: CGSize(width: 480, height: 360))
        videoScene.backgroundColor = .clear
        // center our video to the size of our video scene
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        // invert our video so it does not look upside down
        videoNode.yScale = -1.0
        // add the video to our scene
        videoScene.addChild(videoNode)

        let plane = SCNPlane(width: 0.4, height: 0.3)
        plane.firstMaterial?.diffuse.contents = videoScene
        
        let planeNode = SCNNode(geometry: plane)

        planeNode.position = SCNVector3(x, y, z)
        planeNode.eulerAngles.x = -.pi / 2
        
        self.sceneView.scene.rootNode.addChildNode(planeNode)
        
        
//        let scene = SCNScene(named: "art.scnassets/tv.scn")
//
//        let tvNode = scene.rootNode.childNode(withName: "tv_node", recursively: true)
//        tvNode?.position = SCNVector3(x, y, z)
//
//        let tvScreenPlaneNode = tvNode?.childNode(withName: "screen", recursively: true)
//        let tvScreenPlaneNodeGeometry = tvScreenPlaneNode?.geometry as! SCNPlane
//
//        let tvVideoNode = SKVideoNode(url: videoURL)
//
//        let videoScene = SKScene(size: CGSize(
//            width: 640,
//            height: 480))
//
//        videoScene.addChild(tvVideoNode)
//
//        tvVideoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
//        tvVideoNode.size = videoScene.size
//
//        let tvScreenMaterial = tvScreenPlaneNodeGeometry.materials.first(where: { $0.name == "video" })
//        tvScreenMaterial?.diffuse.contents = videoScene
//
//        tvVideoNode.play()
//        self.sceneView.scene.rootNode.addChildNode(tvNode!)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            footerViewBottomConstraint.constant = keyboardSize.height + 22
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        footerViewBottomConstraint.constant = 22
    }

    @IBAction private func playButtonTouchUpInside(_ sender: UIButton) {
        urlTextField.endEditing(true)
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration)
    }
}

// MARK: - ARSCNViewDelegate

extension HomeViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)

        plane.materials.first?.diffuse.contents = Config.planeColor

        let planeNode = SCNNode(geometry: plane)

        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        planeNode.eulerAngles.x = -.pi / 2

        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        guard
            let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)

        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}

// MARK: - Configure

private struct Config {
    static let planeColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.4)
    static let paddingTextField: CGFloat = 10
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
