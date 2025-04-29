//
//  ProductosTableViewCell.swift
//  Productos
//
//  Created by DAMII on 27/04/25.
//

import UIKit 

class ListProductosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var IvImagen: UIImageView!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layer.cornerRadius = 10
        backgroundColor = UIColor.clear 
    }

    func configureView(product:Producto?) {
        guard let producto = product else { return }
        lblTitulo.text = producto.title
        lblPrecio.text = String(format: "S/. %.2f", producto.price)
        
        lblDescripcion.text = producto.description 
        lblCategoria.text = producto.category
        
        // Cargar imagen de internet
            if let url = URL(string: producto.image) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.IvImagen.image = UIImage(data: data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.IvImagen.image = UIImage(systemName: "image-asset") // imagen por defecto si falla
                        }
                    }
                }
            } else {
                self.IvImagen.image = UIImage(systemName: "image-asset") // imagen por defecto
            }
    }

}
