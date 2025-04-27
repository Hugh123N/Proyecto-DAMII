//
//  ProductosTableViewCell.swift
//  Productos
//
//  Created by DAMII on 27/04/25.
//

import UIKit

class ProductosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var IvImagen: UIImageView!
    
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
        
        lblTitulo.text = producto.title
        lblTitulo.text = producto.title
    }

}
