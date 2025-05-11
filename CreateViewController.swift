import UIKit

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var comboTextField: UITextField!

    @IBOutlet var nombretxt: UITextField!
    @IBOutlet var desctxt: UITextField!
    @IBOutlet var preciotxt: UITextField!
    @IBOutlet var stocktxt: UITextField!
    @IBOutlet var categoriatxt: UITextField!
    @IBOutlet var colortxt: UITextField!
    
    let opciones = ["Men´s clothing", "Jewelery", "Calvin Clein", "Pieers"]
    let picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self

        comboTextField.inputView = picker
        comboTextField.placeholder = "Selecciona una categoria"
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opciones.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return opciones[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        comboTextField.text = opciones[row]
        comboTextField.resignFirstResponder()
    }
    
    
    @IBAction func guardarProducto(_ sender: Any) {
        guard let titulo = nombretxt.text, !titulo.isEmpty,
                  let descripcion = desctxt.text, !descripcion.isEmpty,
                  let precioTexto = preciotxt.text, let precio = Double(precioTexto),
                  let stockTexto = stocktxt.text, let _ = Int(stockTexto),
                  let categoria = comboTextField.text, !categoria.isEmpty,
                  let color = colortxt.text, !color.isEmpty
            else {
                mostrarAlerta("Todos los campos son obligatorios y deben tener el formato correcto.")
                return
            }

            let nuevoID = Int.random(in: 1...10000)

            let nuevoProducto = Producto(
                id: nuevoID,
                title: titulo,
                price: precio,
                description: descripcion,
                category: categoria,
                image: color
            )
            mostrarAlertaExito("Producto creado exitosamente")
            
            limpiarCampos()
    }

    func mostrarAlerta(_ mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }

    func mostrarAlertaExito(_ mensaje: String) {
        let alerta = UIAlertController(title: "Éxito", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let productosVC = storyboard.instantiateViewController(withIdentifier: "ProductosViewController") as? ProductosViewController {
                    self.navigationController?.pushViewController(productosVC, animated: true)
                }
            }))
        present(alerta, animated: true, completion: nil)
    }

    
    func limpiarCampos() {
        nombretxt.text = ""
        desctxt.text = ""
        preciotxt.text = ""
        stocktxt.text = ""
        comboTextField.text = ""
        colortxt.text = ""
    }

    
}
