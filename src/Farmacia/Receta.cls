/// Datos de la receta medica. Objeto EMBEBIDO dentro de la venta;
/// solo se llena cuando la venta incluye un medicamento controlado.
Class Farmacia.Receta Extends %SerialObject
{

/// Nombre del medico que receta.
Property Medico As %String(MAXLEN = 80);

/// Cedula profesional del medico (de 7 a 8 digitos).
Property Cedula As %String(MAXLEN = 8, PATTERN = "7.8N");

/// Fecha en que se expidio la receta.
Property Fecha As %Date;

Storage Default
{
<Data name="RecetaState">
<Value name="1">
<Value>Medico</Value>
</Value>
<Value name="2">
<Value>Cedula</Value>
</Value>
<Value name="3">
<Value>Fecha</Value>
</Value>
</Data>
<State>RecetaState</State>
<StreamLocation>^Farmacia.RecetaS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}