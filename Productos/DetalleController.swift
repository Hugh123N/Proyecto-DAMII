
import UIKit

class DetalleController: UIViewController {
    
   
    @IBOutlet weak var textError: UILabel!
    @IBOutlet weak var prueba: UITextField!
    @IBOutlet weak var objImagen: UIImageView!
    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var textTitulo: UILabel!
    @IBOutlet weak var textDescripcion: UILabel!
    @IBOutlet weak var textPrice: UILabel!
    @IBOutlet weak var textCategoria: UILabel!
    
    var idProducto: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(id: idProducto)
    }
    
    
    @IBAction func AddButton(_ sender: Any) {
        if let idString = self.prueba.text, let id = Int(idString) {
            fetchData(id: id)
            } else {
                self.idText.text = "Error: ID inválido."
            }
    }
    
    func fetchData(id: Int){
        let urlSTR = "https://fakestoreapi.com/products/\(id)"
        
        guard let url = URL(string: urlSTR) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.textError.text = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.textError.text = "No se recibió data"
                }
                return
            }
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
                        
                        self.idText.text = String(id)
                        if let title = jsonResponse?["title"] as? String {
                            self.textTitulo.text = title
                        } else {
                            self.textTitulo.text = "titulo no encontrado"
                        }
                        if let descripcion = jsonResponse?["description"] as? String {
                            self.textDescripcion.text = descripcion
                        } else {
                            self.textDescripcion.text = "body no encontrado"
                        }
                        if let precio = jsonResponse?["price"] as? String {
                            self.textPrice.text = "\(precio)"
                        } else {
                            self.textPrice.text = "precio no encontrado"
                        }
                        if let categoria = jsonResponse?["category"] as? String {
                            self.textCategoria.text = categoria
                        } else {
                            self.textCategoria.text = "precio no encontrado"
                        }
                        if let imagenURLString = jsonResponse?["image"] as? String,
                            let imagenURL = URL(string: imagenURLString) {
                            self.downloadImage(from: imagenURL)
                        } else {
                            self.objImagen.image = nil
                        }
                    }
            } catch {
                DispatchQueue.main.async {
                    self.textError.text = "Fallo la convercion a JSON"
                }
            }
        }
        print(task)
        task.resume()
    }
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.objImagen.image = image
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.textError.text = "No se pudo cargar la imagen"
                    self.objImagen.image = nil
                }
            }
        }
        task.resume()
    }

}

