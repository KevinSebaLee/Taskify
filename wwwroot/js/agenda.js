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
    events: function(fetchInfo, successCallback, failureCallback) {
        successCallback(fetchEvents());
    },
    select: function(info) {
        var title = prompt('Enter Event Title:');
        var description = prompt('Enter Event Description:');
        if (title && description) {
            var startDate = prompt('Enter Start Date and Time (YYYY-MM-DDTHH:MM):', info.startStr);
            var endDate = prompt('Enter End Date and Time (YYYY-MM-DDTHH:MM):', info.endStr);
            if (startDate && endDate) {
                var event = { id: Date.now().toString(), title: title, description: description, start: startDate, end: endDate };
                saveEvent(event);
                calendar.addEvent(event);
            }
        }
        calendar.unselect();
    },
    eventClick: function(info) {
        var event = info.event;
        var description = event.extendedProps.description;
        alert('Title: ' + event.title + '\nDescription: ' + description);
        if (confirm('Do you want to delete this event?')) {
            info.event.remove();
            deleteEvent(info.event.id);
        }
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