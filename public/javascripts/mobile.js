$(document).ready(function() {
    $('#find-code-button').click(function() {
        $.mobile.changePage("/" + $('#find-code-input').val());
    });
});
