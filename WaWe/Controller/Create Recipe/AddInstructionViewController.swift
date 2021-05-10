//
//  AddInstructionViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 19/04/2021.
//

import UIKit

class AddInstructionViewController: UIViewController {
    
    weak var delegate: PassingDataDelegateProtocol?
    
    @IBOutlet weak var instructionTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.updateStringData(for: instructionTV.text)
    }
    
    @IBAction func tappedAddInstructionButton(_ sender: Any) {
        confirmationAlerte(nil, "Les instructions ont bien été ajoutées à la recette.")
    }
}
//MARK: - Alerte
extension AddInstructionViewController {
    ///user Alerte to confirme action
    private func confirmationAlerte(_ title: String?, _ message: String?) {
        let confirmationAlerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(confirmationAlerte, animated: true, completion: nil)
        
        let time = DispatchTime.now() + 1.1
        DispatchQueue.main.asyncAfter(deadline: time){
          confirmationAlerte.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

