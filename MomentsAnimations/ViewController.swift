//
//  ViewController.swift
//  MomentsAnimations
//
//  Created by Shahin on 2019-09-05.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var voiceTriggerView: VoiceTriggerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        voiceTriggerView.addPulseAnimation()
    }
}

