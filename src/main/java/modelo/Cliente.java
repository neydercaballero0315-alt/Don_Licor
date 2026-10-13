package modelo;

public class Cliente {
    private int id;
    private String tipoDoc;
    private String razonSoc;
    private String numDoc;
    private String telefono;
    private String direccion;

    // Constructor vacío
    public Cliente() {}

    // --- GETTERS y SETTERS ---
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getTipoDoc() {
        return tipoDoc;
    }
    public void setTipoDoc(String tipoDoc) {
        this.tipoDoc = tipoDoc;
    }

    public String getRazonSoc() {
        return razonSoc;
    }
    public void setRazonSoc(String razonSoc) {
        this.razonSoc = razonSoc;
    }

    public String getNumDoc() {
        return numDoc;
    }
    public void setNumDoc(String numDoc) {
        this.numDoc = numDoc;
    }

    public String getTelefono() {
        return telefono;
    }
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
}