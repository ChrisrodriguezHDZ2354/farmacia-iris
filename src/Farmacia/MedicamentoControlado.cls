/// Medicamento que solo se vende con receta (antibioticos, psicotropicos).
/// HEREDA todo de Medicamento y REDEFINE Tipo() y RequiereReceta().
Class Farmacia.MedicamentoControlado Extends Farmacia.Medicamento
{

/// Grupo de control sanitario.
Property Grupo As %String(VALUELIST = ",Antibiotico,Psicotropico,Estupefaciente") [ Required ];

Method Tipo() As %String
{
    quit "Controlado"
}

/// Siempre requiere receta medica.
Method RequiereReceta() As %Boolean
{
    quit 1
}

Storage Default
{
<Data name="MedicamentoControladoDefaultData">
<Subscript>"MedicamentoControlado"</Subscript>
<Value name="1">
<Value>Grupo</Value>
</Value>
</Data>
<DefaultData>MedicamentoControladoDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}