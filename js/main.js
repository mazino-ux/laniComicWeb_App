// Add event listeners to all "View" links
document.querySelectorAll('.view-link').forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault(); // Prevent default link behavior

        const imageSrc = link.getAttribute('data-image'); // Get the image source
        const title = link.getAttribute('data-title'); // Get the comic title

        // Create the popup
        Swal.fire({
            title: title,
            html: `
                <img src="${imageSrc}" alt="${title}" style="width: 50%; max-width: 150px; margin: 20px 0;">
                <div class="popup-buttons">
                    <button class="want-button">Want</button>
                    <button class="add-to-cart-button">Add to Cart</button>
                </div>
            `,
            showCloseButton: true,
            showConfirmButton: false,
            customClass: {
                popup: 'custom-popup',
            },
        });

        // Add event listeners to the buttons inside the popup
        document.querySelector('.want-button')?.addEventListener('click', () => {
            Swal.fire('Added to Want List!', '', 'success');
        });

        document.querySelector('.add-to-cart-button')?.addEventListener('click', () => {
            Swal.fire('Added to Cart!', '', 'success');
        });
    });
});