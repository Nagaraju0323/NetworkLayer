//
//  HomeView.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 20/07/23.
//

import UIKit

class HomeView: UIViewController {

    let viewModel = LanguagesViewModel()
    @IBOutlet weak var tblLanguges:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.load(){
            self.tblLanguges.reloadData()
        }
    }
}


extension HomeView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
      
        cell.lblLanguageName.text = viewModel.language[indexPath.row].langName
        return cell
    }
}


class CustomCell:UITableViewCell{
    @IBOutlet weak var lblLanguageName:UILabel!
    
}
