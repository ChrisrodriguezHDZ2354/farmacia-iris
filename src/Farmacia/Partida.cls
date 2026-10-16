/// Un renglon del ticket: que producto, cuantas piezas y a que precio.
/// Es un objeto EMBEBIDO: vive dentro de la venta.
/// En MySQL seria la tabla intermedia "detalle_venta".
Class Farmacia.Partida Extends %SerialObject
{

/// REFERENCIA al producto vendido.
Property Producto As Farmacia.Producto [ Required ];

/// Piezas vendidas.
Property Cantidad As %Integer(MINVAL = 1) [ Required ];

/// Precio al momento de la venta (si despues cambia el precio, el ticket no cambia).
Property PrecioUnitario As %Numeric(SCALE = 2) [ Required ];

/// Tasa de IVA aplicada (0 o 0.16).
Property TasaIVA As %Numeric(SCALE = 2);

/// Importe sin IVA: cantidad x precio.
Method Importe() As %Numeric
{
    quit ..Cantidad * ..PrecioUnitario
}

/// IVA de este renglon.
Method IVA() As %Numeric
{
    quit ..Importe() * ..TasaIVA
}

Storage Default
{
<Data name="PartidaState">
<Value name="1">
<Value>Producto</Value>
</Value>
<Value name="2">
<Value>Cantidad</Value>
</Value>
<Value name="3">
<Value>PrecioUnitario</Value>
</Value>
<Value name="4">
<Value>TasaIVA</Value>
</Value>
</Data>
<State>PartidaState</State>
<StreamLocation>^Farmacia.PartidaS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}