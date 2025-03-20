class Popup {
    private popupContainer: HTMLElement;
    private popupImage: HTMLImageElement;
    private wantButton: HTMLButtonElement;
    private addToCartButton: HTMLButtonElement;

    constructor() {
        // Create the popup container
        this.popupContainer = document.createElement("div");
        this.popupContainer.classList.add("popup-container");

        // Create the popup content
        const popupContent = document.createElement("div");
        popupContent.classList.add("popup-content");

        // Create the image element
        this.popupImage = document.createElement("img");
        this.popupImage.classList.add("popup-image");

        // Create the "Want" button
        this.wantButton = document.createElement("button");
        this.wantButton.classList.add("popup-button", "want-button");
        this.wantButton.textContent = "Want";

        // Create the "Add to Cart" button
        this.addToCartButton = document.createElement("button");
        this.addToCartButton.classList.add("popup-button", "add-to-cart-button");
        this.addToCartButton.textContent = "Add to Cart";

        // Append elements to the popup content
        popupContent.appendChild(this.popupImage);
        popupContent.appendChild(this.wantButton);
        popupContent.appendChild(this.addToCartButton);

        // Append the popup content to the container
        this.popupContainer.appendChild(popupContent);

        // Add the popup container to the body
        document.body.appendChild(this.popupContainer);

        // Add event listeners for buttons
        this.wantButton.addEventListener("click", () => this.handleWant());
        this.addToCartButton.addEventListener("click", () => this.handleAddToCart());

        // Close popup when clicking outside
        this.popupContainer.addEventListener("click", (event) => {
            if (event.target === this.popupContainer) {
                this.close();
            }
        });
    }

    // Open the popup with a specific image
    open(imageSrc: string) {
        this.popupImage.src = imageSrc;
        this.popupContainer.style.display = "flex";
    }

    // Close the popup
    close() {
        this.popupContainer.style.display = "none";
    }

    // Handle "Want" button click
    private handleWant() {
        alert("Added to Want List!");
        this.close();
    }

    // Handle "Add to Cart" button click
    private handleAddToCart() {
        alert("Added to Cart!");
        this.close();
    }
}

// Export the Popup class
export default Popup;