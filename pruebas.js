function saludar () {alert("Hola mundo!");}

const imagen = document.getElementById('escudo');

// Agrega un evento de clic a la imagen
imagen.addEventListener('click', function() {
    // Crea un elemento de div para el pop-up
    const popup = document.createElement('div');
    popup.className = 'popup';
    
    // Agrega el contenido del anuncio al pop-up
    popup.textContent = 'Hola Mundo';
    
    // Agrega el pop-up al cuerpo del documento
    document.body.appendChild(popup);
});