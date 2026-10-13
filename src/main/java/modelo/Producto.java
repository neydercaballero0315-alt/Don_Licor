package modelo;

public class Producto {
    private int id;
    private String nombre;
    private int idCepa; // ✅ DEBE ESTAR AQUÍ
    private String categoria;
    private double precio;
    private int stock;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    // ✅ ESTOS DOS SON OBLIGATORIOS
    public int getIdCepa() { return idCepa; }
    public void setIdCepa(int idCepa) { this.idCepa = idCepa; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}