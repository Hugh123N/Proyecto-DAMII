//
//  ProductosViewController.swift
//  Productos
//
//  Created by DAMII on 27/04/25.
//

import UIKit

class ProductosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListaProductosTableViewCell.ListaProductosTableViewCellDelegate {
    func eliminarProducto(idProducto: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let deleteVC = storyboard.instantiateViewController(withIdentifier: "DeleteViewController") as? DeleteViewController {
            deleteVC.idProducto = idProducto
            navigationController?.pushViewController(deleteVC, animated: true)
        }
    }
    
    func verDetalleProducto(idProducto: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetalleController") as? DetalleController {
            detalleVC.idProducto = idProducto
            print("id: \(idProducto)")
            navigationController?.pushViewController(detalleVC, animated: true)
        }
    }

    
    
    var mail:String!

    @IBOutlet weak var tbProductos: UITableView!
    var arrayProductos = [Producto]()
    var productoSeleccionado: Producto?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        fetchData()
    }
    
    func configureTableView() {
        tbProductos.delegate = self
        tbProductos.dataSource = self
        tbProductos.register(UINib(nibName: "ListaProductosTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
        tbProductos.rowHeight = 260
        tbProductos.showsVerticalScrollIndicator = false
        tbProductos.separatorStyle = .none
    } 
    
    func fetchData() {
        let webService = "https://fakestoreapi.com/products"
        guard let url = URL(string: webService) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                print("Error de conexión: \(String(describing: error?.localizedDescription))")
                return
            }
            do { 
                guard let dataJSON = data else { return }
                self?.arrayProductos = try JSONDecoder().decode([Producto].self, from: dataJSON)
                DispatchQueue.main.async {
                    print("Productos descargados: \(self?.arrayProductos.count ?? 0)")
                    self?.tbProductos.reloadData()
                }
            } catch {
                print("Error al parsear los datos: \(error)") 
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tbProductos.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as? ListaProductosTableViewCell else {
            return UITableViewCell()
        }
        
        let producto = arrayProductos[indexPath.row]
        celda.configureView(product: producto)
        celda.delegate = self
        return celda
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
