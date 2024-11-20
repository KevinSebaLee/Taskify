const Contraseña = document.getElementById('Contraseña');
const Mayusculas = document.getElementById('Mayusculas');
const Caracteres = document.getElementById('Caracteres');
const Numeros = document.getElementById('Numeros');
const Registrarse = document.getElementById('registrarse');
const ConfirmarContraseña = document.getElementById('ConfirmarContraseña');
const MostrarMensaje = document.getElementById('MostrarMensaje');
const contraseñaSegura = new RegExp("^(?=.*[A-Z])(?=.*[0-9]).{8,}$");
const contraseñaCaracteres = new RegExp("^.{8,}$");
const contraseñaNumeros = new RegExp("^(?=.*[0-9]).+$");
const contraseñaMayuscula = new RegExp("^(?=.*[A-Z]).+$");

MostrarMensaje.hidden = true;
Mayusculas.style.color = 'red';
Caracteres.style.color = 'red';
Numeros.style.color = 'red';
MostrarMensaje.style.color = 'red';

Contraseña.addEventListener('input', () => {
    const passwordValue = Contraseña.value;

    Mayusculas.style.color = 'black';
    Caracteres.style.color = 'black';
    Numeros.style.color = 'black';

    if(!contraseñaSegura.test(passwordValue) || Contraseña.value != ConfirmarContraseña.value){
        if (!contraseñaCaracteres.test(passwordValue)) {
            Caracteres.style.color = 'red';
        }
        if (!contraseñaMayuscula.test(passwordValue)) {
            Mayusculas.style.color = 'red';
        }
        if (!contraseñaNumeros.test(passwordValue)) {
            Numeros.style.color = 'red';
        }
        
        Registrarse.style.opacity = 0.6;
        Registrarse.disabled = true;
    }
    else{
        MostrarMensaje.hidden = true;
        Registrarse.style.opacity = 1;
        Registrarse.disabled = false;
    }
});

ConfirmarContraseña.addEventListener('input', () => {
    if(Contraseña.value != ConfirmarContraseña.value){
        console.log(Contraseña);
        console.log(ConfirmarContraseña);
        MostrarMensaje.hidden = false;
        Registrarse.style.opacity = 0.6;
        Registrarse.disabled = true;
    }
    else{
        MostrarMensaje.hidden = true;
        Registrarse.style.opacity = 1;
        Registrarse.disabled = false;    
    }
});