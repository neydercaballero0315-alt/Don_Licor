package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;
import modelo.HorarioEmpleado;

public class HorarioEmpleadoDAO {
    
    public boolean guardar(HorarioEmpleado h) {
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return false;
        String sql = "INSERT INTO horario_empleados (nombre_empleado, dia, hora_entrada, hora_salida, id_turno) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, h.getNombreEmpleado());
            ps.setString(2, h.getDia());
            ps.setString(3, h.getHoraEntrada());
            ps.setString(4, h.getHoraSalida());
            ps.setInt(5, h.getIdTurno());
            int filas = ps.executeUpdate();
            ps.close(); con.close();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error guardar horario: " + e.getMessage());
            return false;
        }
    }

    public List<HorarioEmpleado> listarTodos() {
        List<HorarioEmpleado> lista = new ArrayList<>();
        Conexion cn = new Conexion();
        Connection con = cn.conectar();
        if (con == null) return lista;
        String sql = "SELECT he.*, t.nombre AS nombre_turno "
                   + "FROM horario_empleados he "
                   + "LEFT JOIN turnos t ON he.id_turno = t.id "
                   + "ORDER BY he.id DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HorarioEmpleado h = new HorarioEmpleado();
                h.setId(rs.getInt("id"));
                h.setNombreEmpleado(rs.getString("nombre_empleado"));
                h.setDia(rs.getString("dia"));
                h.setHoraEntrada(rs.getString("hora_entrada"));
                h.setHoraSalida(rs.getString("hora_salida"));
                h.setIdTurno(rs.getInt("id_turno"));
                h.setNombreTurno(rs.getString("nombre_turno"));
                lista.add(h);
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            System.out.println("❌ Error listar horarios: " + e.getMessage());
        }
        return lista;
    }
}