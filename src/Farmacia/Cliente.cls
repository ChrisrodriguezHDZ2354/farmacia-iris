/// Cliente registrado de la farmacia (opcional en cada venta).
Class Farmacia.Cliente Extends %Persistent
{

/// Nombre completo. Obligatorio.
Property Nombre As %String(MAXLEN = 80) [ Required ];

/// Telefono a 10 digitos (PATTERN = 10N: exactamente diez numeros).
Property Telefono As %String(MAXLEN = 10, PATTERN = "10N");

/// Puntos acumulados por sus compras (1 punto por cada 10 pesos).
Property Puntos As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Storage Default
{
<Data name="ClienteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nombre</Value>
</Value>
<Value name="3">
<Value>Telefono</Value>
</Value>
<Value name="4">
<Value>Puntos</Value>
</Value>
</Data>
<DataLocation>^Farmacia.ClienteD</DataLocation>
<DefaultData>ClienteDefaultData</DefaultData>
<IdLocation>^Farmacia.ClienteD</IdLocation>
<IndexLocation>^Farmacia.ClienteI</IndexLocation>
<StreamLocation>^Farmacia.ClienteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}