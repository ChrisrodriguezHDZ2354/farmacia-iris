/// Un medicamento es un Producto con datos sanitarios.
/// HEREDA codigo, nombre, precio, existencia y proveedor, y REDEFINE
/// Tipo(), TasaIVA() y PuedeVenderse().
Class Farmacia.Medicamento Extends Farmacia.Producto
{

/// Sustancia activa (nombre generico), por ejemplo "Paracetamol".
Property SustanciaActiva As %String(MAXLEN = 80) [ Required ];

/// Forma farmaceutica: solo se aceptan estos valores.
Property Presentacion As %String(VALUELIST = ",Tabletas,Capsulas,Jarabe,Suspension,Inyectable,Pomada,Gotas") [ Required ];

/// Concentracion, por ejemplo "500 mg" o "100 mg/5 ml".
Property Concentracion As %String(MAXLEN = 30);

/// Fecha de caducidad del lote en existencia. Obligatoria.
Property Caducidad As %Date [ Required ];

Method Tipo() As %String
{
    quit "Medicamento"
}

/// Los medicamentos tienen tasa 0 % de IVA.
Method TasaIVA() As %Numeric
{
    quit 0
}

/// Indica si ya caduco (la fecha de caducidad es anterior a hoy).
Method Caducado() As %Boolean
{
    quit ..Caducidad < +$horolog
}

/// Un medicamento caducado NO se puede vender.
Method PuedeVenderse() As %Status
{
    if ..Caducado() {
        quit $$$ERROR($$$GeneralError, ..Nombre_" esta caducado ("_$zdate(..Caducidad, 3)_") y no se puede vender")
    }
    quit $$$OK
}

Storage Default
{
<Data name="MedicamentoDefaultData">
<Subscript>"Medicamento"</Subscript>
<Value name="1">
<Value>SustanciaActiva</Value>
</Value>
<Value name="2">
<Value>Presentacion</Value>
</Value>
<Value name="3">
<Value>Concentracion</Value>
</Value>
<Value name="4">
<Value>Caducidad</Value>
</Value>
</Data>
<DefaultData>MedicamentoDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}