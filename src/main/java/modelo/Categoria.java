package modelo;

public class Categoria {
    // Atributos
    private int id;
    private String nombre;
    private String descripcion;  // ✅ Agregado

    // Constructor vacío
    public Categoria() {}

    // Getters y Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    // ✅ Los que faltaban:
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
}