/// Una venta (ticket) del punto de venta.
/// Contiene sus partidas (embebidas), una receta opcional (embebida)
/// y una referencia opcional al cliente.
Class Farmacia.Venta Extends %Persistent
{

/// Fecha y hora de la venta (UTC). Se llena sola.
Property Fecha As %TimeStamp [ InitialExpression = {$zdatetime($horolog, 3)}, Required ];

/// REFERENCIA al cliente (puede quedar vacia: "publico en general").
Property Cliente As Farmacia.Cliente;

/// COLECCION de objetos embebidos: los renglones del ticket.
Property Partidas As list Of Farmacia.Partida;

/// Receta medica (objeto embebido), solo si se vendio un controlado.
Property Receta As Farmacia.Receta;

/// Totales calculados por el metodo Calcular().
Property Subtotal As %Numeric(SCALE = 2);

Property IVA As %Numeric(SCALE = 2);

Property Total As %Numeric(SCALE = 2);

/// Suma los importes y el IVA de todas las partidas.
Method Calcular()
{
    set sub = 0, iva = 0
    for i = 1:1:..Partidas.Count() {
        set p = ..Partidas.GetAt(i)
        set sub = sub + p.Importe()
        set iva = iva + p.IVA()
    }
    set ..Subtotal = $normalize(sub, 2)
    set ..IVA = $normalize(iva, 2)
    set ..Total = $normalize(sub + iva, 2)
}

/// Registra una venta completa dentro de una TRANSACCION:
/// o se guarda todo (venta + descuento de existencias), o no se guarda nada.
/// datos es un objeto JSON: {"clienteId":"1","partidas":[{"productoId":"3","cantidad":2}],
///                           "receta":{"medico":"...","cedula":"1234567","fecha":"2026-10-14"}}
ClassMethod Registrar(datos As %DynamicObject, Output venta As Farmacia.Venta) As %Status
{
    set venta = "", sc = $$$OK
    try {
        TSTART
        set v = ..%New()
        if datos.clienteId '= "" {
            set v.Cliente = ##class(Farmacia.Cliente).%OpenId(datos.clienteId)
            if '$isobject(v.Cliente) $$$ThrowStatus($$$ERROR($$$GeneralError, "No existe el cliente "_datos.clienteId))
        }
        if '$isobject(datos.partidas) || (datos.partidas.%Size() = 0) {
            $$$ThrowStatus($$$ERROR($$$GeneralError, "La venta no tiene productos"))
        }
        set necesitaReceta = 0
        set iter = datos.partidas.%GetIterator()
        while iter.%GetNext(.k, .linea) {
            set prod = ##class(Farmacia.Producto).%OpenId(linea.productoId)
            if '$isobject(prod) $$$ThrowStatus($$$ERROR($$$GeneralError, "No existe el producto "_linea.productoId))
            $$$ThrowOnError(prod.Descontar(linea.cantidad))
            if prod.RequiereReceta() set necesitaReceta = 1
            set p = ##class(Farmacia.Partida).%New()
            set p.Producto = prod, p.Cantidad = linea.cantidad
            set p.PrecioUnitario = prod.Precio, p.TasaIVA = prod.TasaIVA()
            do v.Partidas.Insert(p)
            $$$ThrowOnError(prod.%Save())
        }
        if necesitaReceta {
            set r = datos.receta
            if '$isobject(r) || (r.medico = "") || (r.cedula = "") {
                $$$ThrowStatus($$$ERROR($$$GeneralError, "La venta incluye un medicamento controlado: captura el medico y la cedula de la receta"))
            }
            set v.Receta.Medico = r.medico, v.Receta.Cedula = r.cedula
            set v.Receta.Fecha = $zdateh(r.fecha, 3, , , , , , , +$horolog)
        }
        do v.Calcular()
        $$$ThrowOnError(v.%Save())
        if $isobject(v.Cliente) {
            set v.Cliente.Puntos = v.Cliente.Puntos + (v.Total \ 10)
            $$$ThrowOnError(v.Cliente.%Save())
        }
        TCOMMIT
        set venta = v
    } catch ex {
        if $tlevel > 0 TROLLBACK
        set sc = ex.AsStatus()
    }
    quit sc
}

Storage Default
{
<Data name="VentaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Fecha</Value>
</Value>
<Value name="3">
<Value>Cliente</Value>
</Value>
<Value name="4">
<Value>Partidas</Value>
</Value>
<Value name="5">
<Value>Receta</Value>
</Value>
<Value name="6">
<Value>Subtotal</Value>
</Value>
<Value name="7">
<Value>IVA</Value>
</Value>
<Value name="8">
<Value>Total</Value>
</Value>
</Data>
<DataLocation>^Farmacia.VentaD</DataLocation>
<DefaultData>VentaDefaultData</DefaultData>
<IdLocation>^Farmacia.VentaD</IdLocation>
<IndexLocation>^Farmacia.VentaI</IndexLocation>
<StreamLocation>^Farmacia.VentaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}