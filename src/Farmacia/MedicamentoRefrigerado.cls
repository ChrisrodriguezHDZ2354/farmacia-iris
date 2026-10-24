/// Medicamento que debe conservarse en refrigeracion (insulinas, vacunas).
/// HEREDA todo de Medicamento y REDEFINE Tipo().
Class Farmacia.MedicamentoRefrigerado Extends Farmacia.Medicamento
{

/// Temperatura maxima de conservacion en grados Celsius (de 2 a 8).
Property TemperaturaMax As %Integer(MAXVAL = 8, MINVAL = 2) [ Required ];

Method Tipo() As %String
{
    quit "Refrigerado"                          // REDEFINE el metodo de Medicamento
}

}