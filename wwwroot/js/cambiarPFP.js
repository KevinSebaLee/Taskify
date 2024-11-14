const IdUsuario = document.getElementById('idUsuario').value;

$(document).ready(function() {
    $("#changeProfilePicLink").click(function(event) {
        event.preventDefault();
        $("#profilePicInput").click();
    });

    $("#profilePicInput").change(function(event) {
        var formData = new FormData();
        formData.append('profilePic', event.target.files[0]);
        formData.append('IdUsuario', IdUsuario); // Ensure IdUsuario is defined

        $.ajax({
            url: '/Home/CambiarFotoPerfil',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                $("#changeProfilePicLink img").attr('src', response.newProfilePicUrl);
            },
            error: function(xhr, status, error) {
                alert('Failed to upload profile picture. Please try again.');
            }
        });
    });
});