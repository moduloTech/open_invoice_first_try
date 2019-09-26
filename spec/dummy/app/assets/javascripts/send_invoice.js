(function ($) {
  $(function () {
    const newRecipient = "<div style='margin-top: 8px'>\n" +
                         "  <input type='hidden' name='recipients[][email]' class='js-email'>\n" +
                         "  <input type='hidden' name='recipients[][name]' class='js-name'>\n" +
                         "  <span></span>\n" +
                         "  <a href='javascript:;' style='margin-left: 8px; text-decoration: none'>&times;</a>\n" +
                         "</div>";
    const form = $('#send_invoice_form');
    const submitButton = form.find('button.js-submit');
    const addButton = $('#add_recipient');
    const nameInput = $('#new_name');
    const emailInput = $('#new_email');
    const onInput = function () {
      addButton.toggleClass('disabled', nameInput.val().length === 0 || emailInput.val().length === 0);
    };
    nameInput.on('input', onInput);
    emailInput.on('input', onInput);

    const addRecipient = function (name, email, text) {
      const recipient = $(newRecipient);
      recipient.find('a').on('click', function () {
        $(this).closest('div').remove();
        if (form.find('.js-recipient').length === 0) {
          submitButton.addClass('disabled');
        }
      });
      recipient.find('input.js-name').val(name);
      recipient.find('input.js-email').val(email);
      recipient.find('span').text(text || `${name} <${email}>`);
      addButton.after(recipient);
      submitButton.removeClass('disabled');
    };

    addButton.on('click', function () {
      addRecipient(nameInput.val(), emailInput.val());
      nameInput.val('');
      emailInput.val('');
      addButton.addClass('disabled');
    });

    $('#existing').on('change', function () {
      const existing = $(this).find('option:selected');
      existing && addRecipient(null, existing.val(), existing.text());
    });

    form.on('submit', function () {
      return !submitButton.hasClass('disabled');
    })
  })
})(jQuery);
