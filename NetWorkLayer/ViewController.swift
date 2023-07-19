//
//  ViewController.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 03/07/23.
//

import UIKit

class ViewController: UIViewController {
   
    let viewModel = LanguagesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

}


class CustomTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
}
