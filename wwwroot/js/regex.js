const Contraseña = document.getElementById('Contraseña');
const Mayusculas = document.getElementById('Mayusculas');
const Caracteres = document.getElementById('Caracteres');
const Numeros = document.getElementById('Numeros');
const contraseñaSegura = new RegExp("^(?=.*[A-Z])(?=.*[0-9]).{8,}$");
const contraseñaCaracteres = new RegExp("^.{8,}$");
const contraseñaNumeros = new RegExp("^(?=.*[0-9]).+$");
const contraseñaMayuscula = new RegExp("^(?=.*[A-Z]).+$");

Contraseña.addEventListener('input', () => {
    const passwordValue = Contraseña.value;

    Mayusculas.style.color = 'black';
    Caracteres.style.color = 'black';
    Numeros.style.color = 'black';

    if (!contraseñaCaracteres.test(passwordValue)) {
        Caracteres.style.color = 'red';
    }
    if (!contraseñaMayuscula.test(passwordValue)) {
        Mayusculas.style.color = 'red';
    }
    if (!contraseñaNumeros.test(passwordValue)) {
        Numeros.style.color = 'red';
    }
});