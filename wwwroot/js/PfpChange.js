$(document).ready(function() {
    $('#changeProfilePicLink').click(function(event) {
        event.preventDefault();
        $('#profilePicModal').show();
    });

    $('#profilePicForm').submit(function(event) {
        event.preventDefault();
        let formData = new FormData(this);

        $.ajax({
            url: '/HomeController/UploadProfilePic',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(response) {
                alert('Profile picture updated successfully!');
                $('#profilePicModal').hide();
            },
            error: function(error) {
                alert('Failed to update profile picture.');
            }
        });
    });
});