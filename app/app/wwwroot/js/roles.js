document.addEventListener("DOMContentLoaded", function () {
   
    var nombre = document.getElementById("nombre").value;

    
    console.log("nombre: " + nombre);

    const elemento = document.getElementById('_Nombre');
    if (elemento) {
        elemento.textContent = nombre;
    }



    if (rolePermissions.hasOwnProperty(rol)) {
        toggleElements(rolePermissions[rol]);
    }
});