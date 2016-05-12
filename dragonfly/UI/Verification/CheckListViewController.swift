/*
 * This file is part of Zum.
 * 
 * Zum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Zum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Zum. If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation


import UIKit

class CheckTableViewCell : UITableViewCell {
    
    var checkList:CheckList!
    
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        self.btnCheckBox.selected = selected
        self.checkList.checked = selected
        super.setSelected(selected, animated: animated)
    }
    
    func bind(checkList:CheckList) {
        self.lblName.text = checkList.name
        self.checkList = checkList
    }
}


class CheckListViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var lblAddressName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblAdressCep: UILabel!
    
    
    var address : Address!
    var dict = [String:[CheckList]]()
    var sections:[String]
        {
        get{
          return Array(dict.keys).sort()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.title = self.address.label
        let topInset = CGRectGetMaxY(self.navigationController!.navigationBar.frame)
        let edgesInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0 )
        self.tableView.contentInset = edgesInset
        self.tableView.scrollIndicatorInsets = edgesInset
        
        self.lblAddressName.text = address.label
        self.lblAddress.text = address.address + "," + address.number + " " + address.neighborhood
        self.lblAdressCep.text = address.zipCode
        

    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as!SubmitChecklistViewController
        controller.address = self.address
        
    }
    func loadData() {
        ApiAddressClient().getAddress(address.id) { (address, response) in
           
            if let address = address {

                self.address = address
                
                let sortedItens = address.checklistItems.sort { $0.name < $1.name }
                
                sortedItens.forEach({
                    let firstLetter = String($0.name.characters.first!).stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())

                    if var arrayCheckList = self.dict[firstLetter] {
                        arrayCheckList.append($0)
                        self.dict[firstLetter] = arrayCheckList;
                    } else{
                        self.dict[firstLetter] = [$0]
                    }
                    
                })
                
                self.tableView.reloadData()
            }
            else {
                
                print("ERRO: "+response.description!)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dict[sections[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("CheckTableViewCell") as! CheckTableViewCell
        
        cell.selectionStyle = .None
        
        let letter = self.sections[indexPath.section].stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        let checkList = self.dict[letter]![indexPath.row]
        cell.bind(checkList)
        return cell
    }
    
    @IBAction func concluirVerficacao(sender: UIButton) {
        
        var selectedItens = [CheckList]()
        
        for (_ , itens) in self.dict {

            selectedItens.appendContentsOf(itens.filter({ $0.checked }))
        }
        
        ApiVerificationClient().verification(self.address.id, checkListItens: selectedItens) { (response) in
            
            // TODO: Tratar o Erro!
            if(response.success) {
                
                print("DEU CERTO!")
            }
            else {
                
                print("Tratar o erro!")
            }
        }
        
        self.performSegueWithIdentifier("SegueConcluir", sender: self.address)
    }
}

