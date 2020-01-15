//
//  ViewController.swift
//  attributed_text
//
//  Created by Dimas on 15.01.2020.
//  Copyright © 2020 T.D.V.DG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var text: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		text.stringTagProcessor = StringTagProcessor(bundle: Bundle.main)
		text.setTextWithTags("It's me, [IC(images/mario.png)] Mario! Are you ok [IC(luigi)] Luigi?")
		// Do any additional setup after loading the view.
	}


}

