function saludar () {alert("Hola mundo!");}

let cart = [];

        function addToCart(productName, price) {
            cart.push({ name: productName, price: price });
            updateCart();
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            updateCart();
        }

        function clearCart() {
            cart = [];
            updateCart();
        }

        function checkout() {
            const successMessage = document.getElementById("success-message");
            successMessage.style.display = "block";
            clearCart();
            setTimeout(() => {
                successMessage.style.display = "none";
            }, 3000); 
        }

        function updateCart() {
            const cartItemsElement = document.getElementById("cart-items");
            const totalElement = document.getElementById("total");
            let total = 0;

            cartItemsElement.innerHTML = "";

            cart.forEach((item, index) => {
                const listItem = document.createElement("li");
                listItem.className = "cart-item";
                listItem.innerHTML = `<span>${item.name}</span><span>$${item.price}</span><button onclick="removeFromCart(${index})">Eliminar</button>`;
                cartItemsElement.appendChild(listItem);
                total += item.price;
            });

            totalElement.textContent = total;
        }