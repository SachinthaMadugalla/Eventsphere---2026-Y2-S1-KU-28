(() => {
    const form = document.getElementById('booking-form');
    if (!form) return;
    const venue = document.getElementById('venueId');
    const status = document.getElementById('venue-status');
    const submit = document.getElementById('submit-booking');
    const fields = ['eventDate', 'startTime', 'endTime', 'guestCount'].map(n => form.elements[n]);
    let revision = 0, pending;
    const reset = message => {
        venue.replaceChildren(new Option(message, ''));
        venue.disabled = true; submit.disabled = true;
    };
    async function refresh() {
        const current = ++revision;
        if (pending) pending.abort();
        reset('Checking availability...');
        const [date, start, end, guests] = fields.map(f => f.value);
        if (fields.some(f => !f.value || !f.checkValidity()) || end <= start) {
            reset('Enter date, times and guest count first');
            status.textContent = 'Choose a valid date, start/end time and guest count. End time must be after start time.';
            return;
        }
        status.textContent = 'Checking available venues...';
        pending = new AbortController();
        try {
            const response = await fetch(form.dataset.venuesUrl + '?' + new URLSearchParams({date, start, end, guests}), {signal: pending.signal});
            if (!response.ok) throw new Error('Could not check availability. Check your details or log in again, then retry.');
            const venues = await response.json();
            if (current !== revision) return;
            if (!Array.isArray(venues)) throw new Error('Please log in again to check availability.');
            reset(venues.length ? 'Select an available venue' : 'No available venues');
            venues.forEach(v => venue.add(new Option(`${v.name} — ${v.location} (up to ${v.capacity} guests)`, v.id)));
            venue.disabled = !venues.length;
            status.textContent = venues.length ? `${venues.length} available venue(s). Availability is checked again when you submit.` : 'No venues match this date, time and guest count. Try another date or time.';
        } catch (error) {
            if (current !== revision || error.name === 'AbortError') return;
            reset('Availability unavailable'); status.textContent = error.message;
        }
    }
    fields.forEach(f => f.addEventListener('input', refresh));
    venue.addEventListener('change', () => { submit.disabled = !venue.value; });
    document.getElementById('refresh-venues').addEventListener('click', refresh);
    form.addEventListener('submit', e => { if (venue.disabled || !venue.value) { e.preventDefault(); status.textContent = 'Choose an available venue before submitting.'; } });
    refresh();
})();
