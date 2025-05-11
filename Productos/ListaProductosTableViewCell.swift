//
//  ListaProductosTableViewCell.swift
//  Productos
//
//  Created by DAMII on 4/05/25.
//

import UIKit

class ListaProductosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var IvImagen: UIImageView!
    var idProducto:Int = 0
    weak var delegate: ListaProductosTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layer.cornerRadius = 10
        backgroundColor = UIColor.clear 
    }
    
    func configureView(product:Producto?) {
        guard let producto = product else { return }
        idProducto = producto.id
        lblTitulo.text = producto.title
        lblPrecio.text = String(format: "S/. %.2f", producto.price)
        
        lblCategoria.text = producto.category 
        
            if let url = URL(string: producto.image) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.IvImagen.image = UIImage(data: data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.IvImagen.image = UIImage(systemName: "image-asset")
                        }
                    }
                }
            } else {
                self.IvImagen.image = UIImage(systemName: "image-asset")
            }
    }
    
    protocol ListaProductosTableViewCellDelegate: AnyObject {
        func verDetalleProducto(idProducto: Int)
        func eliminarProducto(idProducto: Int)
    }
    
    @IBAction func btnVerDetalle(_ sender: Any) {
        delegate?.verDetalleProducto(idProducto: idProducto)
    }
    
    @IBAction func btnEliminar(_ sender: Any) {
        delegate?.eliminarProducto(idProducto: idProducto)
    }
    
}
