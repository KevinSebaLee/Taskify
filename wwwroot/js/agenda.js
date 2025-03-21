document.addEventListener('DOMContentLoaded', function() {
    function fetchEvents() {
        return JSON.parse(localStorage.getItem('calendarEvents')) || [];
    }

    function saveEvent(event) {
        var events = fetchEvents();
        events.push(event);
        localStorage.setItem('calendarEvents', JSON.stringify(events));
    }

    function updateEvent(updatedEvent) {
        var events = fetchEvents();
        events = events.map(event => event.id === updatedEvent.id ? updatedEvent : event);
        localStorage.setItem('calendarEvents', JSON.stringify(events));
    }

    function deleteEvent(eventId) {
        var events = fetchEvents();
        events = events.filter(event => event.id !== eventId);
        localStorage.setItem('calendarEvents', JSON.stringify(events));
    }

    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    editable: true,
    selectable: true,
    selectHelper: true,
    events: function(event, successCallback, failureCallback) {
        $.ajax({
            url: '/Home/ObtenerEventos', // Este endpoint debería devolver los eventos de la base de datos
            type: 'GET',
            success: function(data) {
                var events = data.map(function(event) {
                    return {
                        id: event.id,
                        title: event.title,
                        start: event.start,
                        end: event.end,
                        description: event.description
                    };
                });
                successCallback(fetchEvents());// Pasar los eventos al calendario
            },
            error: function(xhr, status, error) {
                console.error("Error fetching events:", error);
                failureCallback(error); // Si hay error, manejarlo
            }
        });
    },
   
    select: function(info) {
        const Usuario = document.getElementById('Usuario').value;
        document.getElementById('eventStart').value = info.startStr.slice(0, 16);
        document.getElementById('eventEnd').value = info.endStr.slice(0, 16);
    
        const createEventModal = new bootstrap.Modal(document.getElementById('createEventModal'));
        createEventModal.show();
    
        document.getElementById('saveEventButton').onclick = function () {
            let title = document.getElementById('eventTitle').value;
            let description = document.getElementById('eventDescription').value;
            let startDate = document.getElementById('eventStart').value;
            let endDate = document.getElementById('eventEnd').value;
            let Usuario = document.getElementById('Usuario').value; // Assuming this is defined elsewhere
        
            if (title && description && startDate && endDate && new Date(startDate) < new Date(endDate)) {
                var event = {
                    IdUsuario: Usuario,
                    IdContacto: null,
                    Nombre: title,
                    Descripcion: description,
                    FechaInicio: startDate,
                    FechaFin: endDate
                };
        
                console.log("Data being sent:", event);
        
                $.ajax({
                    url: '/Home/CrearEvento',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(event),
                    success: function(savedEvent) {
                        calendar.addEvent({
                            id: savedEvent.id,
                            title: savedEvent.title,
                            start: savedEvent.start,
                            end: savedEvent.end,
                            extendedProps: {
                                description: savedEvent.description
                            }
                        });
        
                        createEventModal.hide();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error saving event:', error);
                        alert('Failed to save the event. Please try again.');
                    }
                });
            } else {
                alert('Please fill out all fields and ensure the dates are valid.');
            }
        };
    
        calendar.unselect();
    },
    
    eventClick: function(info) {
        var event = info.event;
        var description = event.extendedProps.description;
        
        $.ajax({
            url: '/your-endpoint',
            type: 'GET',
            data: { eventId: event.id },
            success: function (response) {
                document.getElementById("eventTitle").textContent = event.title;
                document.getElementById("eventDescription").textContent = response.description;

                var modal = new bootstrap.Modal(document.getElementById("eventModal"));
                modal.show();
            },
            error: function (xhr, status, error) {
                console.error("Error fetching event details:", error);
                alert("Failed to fetch event details. Please try again later.");
            }
        });
    },
    eventDrop: function(info) {
        var updatedEvent = {
            id: info.event.id,
            title: info.event.title,
            description: info.event.extendedProps.description,
            start: info.event.start.toISOString(),
            end: info.event.end ? info.event.end.toISOString() : null
        };
        updateEvent(updatedEvent);
    },
    eventResize: function(info) {
        var updatedEvent = {
            id: info.event.id,
            title: info.event.title,
            description: info.event.extendedProps.description,
            start: info.event.start.toISOString(),
            end: info.event.end ? info.event.end.toISOString() : null
        };
    updateEvent(updatedEvent);
    }
    });
    
    calendar.render();
});