package modelo;

public class Ventas {
    private int id;
    private String fecha;
    private double total;
    private int idCliente;
    private int idMetodoPago;
    private String nombreCliente;
    private String nombreMetodoPago;

    public Ventas() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public int getIdMetodoPago() { return idMetodoPago; }
    public void setIdMetodoPago(int idMetodoPago) { this.idMetodoPago = idMetodoPago; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public String getNombreMetodoPago() { return nombreMetodoPago; }
    public void setNombreMetodoPago(String nombreMetodoPago) { this.nombreMetodoPago = nombreMetodoPago; }

    public int getProductoId() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}