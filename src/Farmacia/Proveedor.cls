/// Laboratorio o distribuidor que surte productos a la farmacia.
/// Equivale a una tabla "proveedor" en MySQL.
Class Farmacia.Proveedor Extends %Persistent
{

/// Nombre comercial. Obligatorio (como NOT NULL).
Property Nombre As %String(MAXLEN = 80) [ Required ];

/// No puede haber dos proveedores con el mismo nombre (como UNIQUE).
Index NombreIdx On Nombre [ Unique ];

/// Telefono de contacto.
Property Telefono As %String(MAXLEN = 20);

/// Correo de pedidos.
Property Email As %String(MAXLEN = 80);

/// RELACION uno a muchos: un proveedor surte muchos productos.
/// El otro lado es Farmacia.Producto.Proveedor.
Relationship Productos As Farmacia.Producto [ Cardinality = many, Inverse = Proveedor ];

Storage Default
{
<Data name="ProveedorDefaultData">
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
<Value>Email</Value>
</Value>
</Data>
<DataLocation>^Farmacia.ProveedorD</DataLocation>
<DefaultData>ProveedorDefaultData</DefaultData>
<IdLocation>^Farmacia.ProveedorD</IdLocation>
<IndexLocation>^Farmacia.ProveedorI</IndexLocation>
<StreamLocation>^Farmacia.ProveedorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}