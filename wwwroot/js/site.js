function ObtenerFechaHoy(){
    const formCompletar = document.getElementById('FechaHoy');

    const Fecha = new Date();

    let Dia = Fecha.getDay();
    let Mes = Fecha.getMonth();
    let Año = Fecha.getFullYear();

    let FechaHoy = `${Dia}-${Mes}-${Año}`;

    formCompletar.value = FechaHoy;
}

ObtenerFechaHoy();