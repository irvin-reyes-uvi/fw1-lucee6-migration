document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('form_confirm_payment');

    // Only add the listener if the form element was found
    if (form) {
        form.addEventListener('submit', (event) => {
            const divMakePaymentEditButton = document.getElementById('div_makepayment_edit_button');
            const divMakePaymentSubmitButton = document.getElementById('div_makepayment_submit_button');

            if (divMakePaymentEditButton) {
                Array.from(divMakePaymentEditButton.children).forEach(child => {
                    child.addEventListener('click', (e) => {
                        e.preventDefault();
                    });
                });
            }

            if (divMakePaymentSubmitButton) {
                Array.from(divMakePaymentSubmitButton.children).forEach(child => {
                    child.addEventListener('click', (e) => {
                        e.preventDefault();
                    });
                });
            }
        });
    }
});
