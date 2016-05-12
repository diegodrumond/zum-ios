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

import UIKit
import KYDrawerController
import AVFoundation

public class VerificationViewController: BaseViewController{

    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var daysCount: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        playSong()
    }
    
    override public func viewWillAppear(animated: Bool) {
       
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        
        ApiVerificationClient().getLast { (validation, response) in
            let dateNow = NSDate().timeIntervalSince1970
            
            let diferenca = Int((dateNow - (validation!.verificationDate/1000)) / 60 / 60 / 24)
            
            self.daysCount.text = String(diferenca)
        }
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    
    func playSong(){
    
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        let url = NSBundle.mainBundle().pathForResource("Mosquito", ofType: ".mp3")
        let audioUrl = NSURL(fileURLWithPath: url!)
        self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioUrl)
        self.audioPlayer.numberOfLoops = 2
        self.audioPlayer.volume = 0.02
        self.audioPlayer.play()

    }
    
    @IBAction func verificationAction(sender: AnyObject) {
        performSegueWithIdentifier("SegueListAddress", sender: self)
    }
    
   
    
    @IBAction func menuAction(sender: AnyObject) {
        
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            drawerController.setDrawerState(.Opened, animated: true)
        }else{
            
            if let drawerController = parentViewController as? KYDrawerController {
                drawerController.setDrawerState(.Opened, animated: true)
            }else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}