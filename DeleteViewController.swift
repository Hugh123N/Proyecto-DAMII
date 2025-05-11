//
//  DeleteViewController.swift
//  Productos
//
//  Created by DAMII on 10/05/25.
//

import UIKit

class DeleteViewController: UIViewController {

    
    @IBOutlet var objImagen: UIImageView!
    @IBOutlet var idText: UITextField!
    @IBOutlet var textDescripcion: UITextField!
    @IBOutlet var textPrice: UITextField!
    @IBOutlet var textCategoria: UIButton!
    
    var idProducto: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(id: idProducto)
    }
    
    @IBAction func eliminarProducto(_ sender: Any) {
        fetchData(id: idProducto)
        self.showSuccessAlertAndNavigateAfterDeletion()
    }
    
    func fetchData(id: Int) {
        let urlSTR = "https://fakestoreapi.com/products/\(id)"
        guard let url = URL(string: urlSTR) else {
            mostrarError("URL inválida")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.mostrarError("Error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.mostrarError("No se recibió data")
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.idText.text = "\(id)"
                        self.textDescripcion.text = json["description"] as? String ?? "Descripción no encontrada"
                        self.textPrice.text = "\(json["price"] ?? "")"
                        self.textCategoria.setTitle(json["category"] as? String ?? "Categoría no encontrada", for: .normal)

                        if let imageUrlStr = json["image"] as? String,
                           let imageUrl = URL(string: imageUrlStr) {
                            self.downloadImage(from: imageUrl)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.mostrarError("Error al convertir JSON")
                }
            }
        }
        task.resume()
    }

    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.objImagen.image = image
                }
            }
        }
        task.resume()
    }

    
    func mostrarError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    func mostrarAlertaExito(_ mensaje: String) {
        let alerta = UIAlertController(title: "Éxito", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let productosVC = storyboard.instantiateViewController(withIdentifier: "ProductosViewController") as? ProductosViewController {
                self.navigationController?.pushViewController(productosVC, animated: true)
            }
        }))
        present(alerta, animated: true)
    }


    func showSuccessAlertAndNavigateAfterDeletion() {

        let alert = UIAlertController(title: "Producto Eliminado", message: "El producto ha sido eliminado correctamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "delete", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    
}
