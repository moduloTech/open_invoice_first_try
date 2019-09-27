(function ($) {
  $(function () {
    if (window.location.pathname !== '/admins/') {
      return
    }

    $('.content .page-header h1').append(
      '<span class="js-check-version text-muted" title="Checking for update...">&nbsp;' +
      '<span class="fa fa-cog fa-spin"></span>' +
      '</span>'
    );
    $.get('/check_version.json').done(function (data) {
      $('.js-check-version').remove();

      if (data.outdated) {
        $('.content .page-header').after(data.alert);
      }
    })
  })
})(jQuery);
