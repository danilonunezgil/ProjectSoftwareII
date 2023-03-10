package libreria.controller;

import libreria.model.Amigo;
import libreria.model.Elemento;
import libreria.model.Estudiante;
import libreria.dto.AmigoDTO;
import libreria.dto.EstudianteDTO;
import libreria.dto.InfoStudentDTO;
import java.util.List;
import java.util.stream.Collectors;


/**
 * Clase que representa los servicios ofrecidos para el motor de Oracle
 * @author Edgar,Danilo y Johan
 */
public class OracleService {
    
    private static OracleService oracleSingleton;
    private final Amigo amigo;
    private final Estudiante estudiante;
    private final Elemento elemento;
    
    
    /**
    * Constructor privado de OracleService
    * @author Edgar,Danilo y Johan
    */
    private OracleService() {
        this.amigo = new Amigo();
        this.estudiante = new Estudiante();
        this.elemento = new Elemento();
    }
    
    /**
    * Este método se encarga de crear e instanciar un unico objeto OracleService
    * @author Edgar,Danilo y Johan
    * @return Objeto de tipo OracleService
    */
    public static OracleService getInstance(){
        if(oracleSingleton == null){
            oracleSingleton = new OracleService();
        }
        return oracleSingleton;
    }
    
    /**
    * Método encargado de ofrecer el servicio crearAmigoOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return Objeto de tipo AmigoDTO creado
    */
    public AmigoDTO ingresarAmigo(){
        AmigoDTO amigoDTO = new AmigoDTO( amigo.crearAmigoOracle());
        return amigoDTO;
    }
    
    /**
    * Método encargado de ofrecer el servicio listarAmigoOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return Lista de objetos de tipo AmigoDTO
    */
    public List<AmigoDTO> listarAmigo(){
        List<Amigo> lista = amigo.listarAmigoOracle();
        return lista.stream().map(AmigoDTO::new).collect(Collectors.toList());
    }
    
    /**
    * Método encargado de ofrecer el servicio actualizarAmigoOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @param amigo Objeto AmigoDTO que se actualizara
    * @return Objeto de tipo AmigoDTO actualizado 
    */
    public AmigoDTO actualizarAmigo(AmigoDTO amigo){
        AmigoDTO amigoDTO = new AmigoDTO(amigo.actualizarAmigoOracle(amigo));
        return amigoDTO ;
    }
    
    /**
    * Método encargado de ofrecer el servicio eliminarAmigoOracle de la clase Amigo
    * @param idAmigo Identificador del amigo a eliminar 
    * @author Edgar,Danilo y Johan 
    */
    public void eliminarAmigo(Number idAmigo){
        amigo.eliminarAmigoOracle(idAmigo);
    }
    
    /**
    * Método encargado de ofrecer el servicio buscarIdAmigoOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @param idAmigo Identificador del amigo a buscar
    * @return Objeto de tipo AmigoDTO encontrado
    */
    public AmigoDTO buscarAmigoId(Number idAmigo){
        AmigoDTO amigoDTO = new AmigoDTO(amigo.buscarIdAmigoOracle(idAmigo));
        return amigoDTO;
    }
    
    /**
    * Método encargado de ofrecer el servicio savePointOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return String con el mensaje de exito o error de savepoint
    */
    public String savePointAmigos(){
        return amigo.savePointOracle();
    }
    
    /**
    * Método encargado de ofrecer el servicio volverSaveOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return String con el mensaje de exito o error de rollback(savepoint)
    */
    public String volverSaveAmigos(){
        return amigo.volverSaveOracle();
    }
    
    /**
    * Método encargado de ofrecer el servicio rollbackOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return String con el mensaje de exito o error de rollback
    */
    public String rollbackAmigos(){
        return amigo.rollbackOracle();
    }
    
    /**
    * Método encargado de ofrecer el servicio commitOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @return String con el mensaje de exito o error de commit
    */
    public String commitAmigos(){
        return amigo.commitOracle();
    }
    
    /*
    public String desconectar(){
        return ConexionOracle.desconectar(OracleService.class);
    }
    */
    
    /**
    * Método encargado de ofrecer el servicio promedioCarreraOracle de la clase Amigo
    * @author Edgar,Danilo y Johan
    * @param cod_est Indetificador del estudiante al cual consultar el promedio
    * @return Number con el promedio del estudiante consultado
    */
    public Number promedioCarrera(Integer cod_est){
        return estudiante.promedioCarreraOracle(cod_est);
    }
    
    /**
    * Método encargado de ofrecer el servicio precioPromedioOracle de la clase Elemento
    * @author Edgar,Danilo y Johan
    * @param cod_ele Identificador del elemento al cual consultar el precio promedio
    * @return Integer con el precio promedio del elemento consultado
    */
    public Integer precioPromedio(Integer cod_ele){
        return elemento.precioPromedioOracle(cod_ele);
    }
    
    /**
    * Método encargado de ofrecer el servicio compararNumerosOracle de la clase Estudiante
    * @author Edgar,Danilo y Johan
    * @param numero1 Primer numero a comparar
    * @param numero2 Segundo numero a comparar
    * @return String con el mensaje de comparacion de los numeros
    */
    public String compararNumeros(Integer numero1, Integer numero2){
        return estudiante.compararNumerosOracle(numero1,numero2);
    }
    
    /**
    * Método encargado de ofrecer el servicio informacionEstudiantesOracle de la clase Estudiante
    * @author Edgar,Danilo y Johan
    * @return Lista con objetos de tipo InfoStudentDTO
    */
    public List<InfoStudentDTO> informacionEstudiantes(){
        return estudiante.informacionEstudiantesOracle();
    }
    
    /**
    * Método encargado ofrecer el servicio buscarIdEstudianteOracle de la clase Estudiante
    * @author Edgar,Danilo y Johan
    * @param idEstudiante Number con el identificador del estudiante que se quiere buscar
    * @return Objeto de tipo EstudianteDTO con toda la informacion del mismo
    */
    public EstudianteDTO buscarIdEstudianteOracle(Number idEstudiante){
        EstudianteDTO estudianteDTO = new EstudianteDTO(estudiante.buscarIdEstudianteOracle(idEstudiante));
        return estudianteDTO;
    }
    
    /**
    * Método encargado ofrecer el servicio guardarFotoCarpetaOracle de la clase Estudiante
    * @author Edgar,Danilo y Johan
    * @param estudianteDTO Objeto de tipo estudiante con la informacion del codigo del estudiante y la foto a guardar
    * @return Arreglo de bytes con toda la informacion de la foto guardada en la carpeta
    */
    public byte[] guardarFotoCarpetaOracle(EstudianteDTO estudianteDTO){
        return estudiante.guardarFotoCarpetaOracle(estudianteDTO);
    }
    
    /**
    * Método encargado ofrecer el servicio guardarFotoBaseOracle de la clase Estudiante
    * @author Edgar,Danilo y Johan
    * @param estudianteDTO Objeto de tipo estudiante con la informacion del codigo del estudiante y la foto a guardar
    * @return Arreglo de bytes con toda la informacion de la foto guardada en la carpeta
    */
    public byte[] guardarFotoBaseOracle(EstudianteDTO estudianteDTO){
        return estudiante.guardarFotoBaseOracle(estudianteDTO);
    }
}
