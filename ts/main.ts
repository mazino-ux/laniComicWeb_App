import Popup from "./Popup";

// Initialize the popup
const popup = new Popup();

// Attach event listeners to all comic cards
document.querySelectorAll(".comic-card").forEach((card) => {
    card.addEventListener("click", (event) => {
        event.preventDefault(); // Prevent default link behavior
        const imageSrc = card.getAttribute("data-image");
        if (imageSrc) {
            popup.open(imageSrc);
        }
    });
});