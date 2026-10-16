/// Superclase de todo lo que vende la farmacia.
/// Medicamento y MedicamentoControlado HEREDAN de ella.
/// Un producto general (cubrebocas, gel, panales) es un objeto de esta misma clase.
Class Farmacia.Producto Extends %Persistent
{

/// Codigo de barras o clave interna. Obligatorio y unico.
Property Codigo As %String(MAXLEN = 20) [ Required ];

Index CodigoIdx On Codigo [ Unique ];

/// Nombre con el que se vende, por ejemplo "Paracetamol 500 mg 10 tabletas".
Property Nombre As %String(MAXLEN = 100) [ Required ];

/// Precio de venta sin IVA. Minimo un centavo, con dos decimales.
Property Precio As %Numeric(MINVAL = 0.01, SCALE = 2) [ Required ];

/// Piezas en existencia. Nunca puede ser negativa.
Property Existencia As %Integer(MINVAL = 0) [ InitialExpression = 0, Required ];

/// Existencia minima: por debajo de este numero hay que resurtir.
Property Minimo As %Integer(MINVAL = 0) [ InitialExpression = 5 ];

/// RELACION: cada producto lo surte un proveedor (lado "uno").
Relationship Proveedor As Farmacia.Proveedor [ Cardinality = one, Inverse = Productos ];

/// Indice para encontrar rapido los productos de un proveedor.
Index ProveedorIdx On Proveedor;

/// Tipo de producto para mostrar en la aplicacion. Las subclases lo redefinen.
Method Tipo() As %String
{
    quit "General"
}

/// Tasa de IVA. En Mexico los productos generales pagan 16 %.
/// Medicamento la REDEFINE (POLIMORFISMO): los medicamentos pagan 0 %.
Method TasaIVA() As %Numeric
{
    quit 0.16
}

/// Indica si para venderlo se necesita receta medica.
Method RequiereReceta() As %Boolean
{
    quit 0
}

/// Revisa si el producto se puede vender. Medicamento agrega la revision de caducidad.
Method PuedeVenderse() As %Status
{
    quit $$$OK
}

/// Descuenta piezas de la existencia (al vender). No guarda: eso lo hace la venta.
Method Descontar(cantidad As %Integer) As %Status
{
    if cantidad < 1 quit $$$ERROR($$$GeneralError, "La cantidad de "_..Nombre_" debe ser al menos 1")
    set sc = ..PuedeVenderse()
    if $$$ISERR(sc) quit sc
    if cantidad > ..Existencia {
        quit $$$ERROR($$$GeneralError, "Existencia insuficiente de "_..Nombre_": hay "_..Existencia_" y se piden "_cantidad)
    }
    set ..Existencia = ..Existencia - cantidad
    quit $$$OK
}

/// Suma piezas a la existencia (entrada de mercancia) y guarda.
Method Surtir(cantidad As %Integer) As %Status
{
    if cantidad < 1 quit $$$ERROR($$$GeneralError, "La cantidad a surtir debe ser al menos 1")
    set ..Existencia = ..Existencia + cantidad
    quit ..%Save()
}

/// Indica si la existencia esta en el minimo o por debajo.
Method BajoMinimo() As %Boolean
{
    quit ..Existencia <= ..Minimo
}

Storage Default
{
<Data name="ProductoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Codigo</Value>
</Value>
<Value name="3">
<Value>Nombre</Value>
</Value>
<Value name="4">
<Value>Precio</Value>
</Value>
<Value name="5">
<Value>Existencia</Value>
</Value>
<Value name="6">
<Value>Minimo</Value>
</Value>
<Value name="7">
<Value>Proveedor</Value>
</Value>
</Data>
<DataLocation>^Farmacia.ProductoD</DataLocation>
<DefaultData>ProductoDefaultData</DefaultData>
<IdLocation>^Farmacia.ProductoD</IdLocation>
<IndexLocation>^Farmacia.ProductoI</IndexLocation>
<StreamLocation>^Farmacia.ProductoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}