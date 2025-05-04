//
//  ViewController.swift
//  Productos
//
//  Created by DAMII on 20/04/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txtPws: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    let predefinedUser = User(email: "admin", password: "admin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnIngresar(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty,
                  let password = txtPws.text, !password.isEmpty else {
                showAlert(message: "Por favor, ingrese todos los campos.")
                return
            }
            
            if validateUser(email: email, password: password) {
                showSuccessAlertAndNavigate()
            } else {
                showAlert(message: "Email o contraseña incorrectos.")
            }
    }
    
    private func validateUser(email: String, password: String) -> Bool {
        return email == predefinedUser.email && password == predefinedUser.password
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TapBard",
           let productos = segue.destination as? ProductosViewController {
            productos.mail = txtEmail.text
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessAlertAndNavigate() {
        let alert = UIAlertController(title: "Login Exitoso", message: "¡Bienvenido Administrador!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { _ in
            //invocar al segue "resumen"
            self.performSegue(withIdentifier: "TapBard", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

