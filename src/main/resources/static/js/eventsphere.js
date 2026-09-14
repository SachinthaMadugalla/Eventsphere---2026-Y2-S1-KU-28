/**
 * EventSphere – Main JavaScript
 * SE2030 | Group 2026-Y2-S1-KU-28
 *
 * Handles: sidebar toggle, alert auto-dismiss,
 * delete confirmation, form validation helpers,
 * star rating display, and general UI utilities.
 */

// ── SIDEBAR TOGGLE (mobile) ────────────────────────────────────────────────
function toggleSidebar() {
    const sidebar = document.querySelector('.es-sidebar');
    if (sidebar) {
        sidebar.classList.toggle('open');
    }
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function (e) {
    const sidebar = document.querySelector('.es-sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    if (!sidebar) return;

    if (window.innerWidth <= 768) {
        if (!sidebar.contains(e.target) && e.target !== toggleBtn) {
            sidebar.classList.remove('open');
        }
    }
});

// ── ALERT AUTO-DISMISS ─────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    const alerts = document.querySelectorAll('.es-alert.auto-dismiss');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function () {
                alert.remove();
            }, 500);
        }, 4000);
    });
});

// ── CONFIRM DELETE ─────────────────────────────────────────────────────────
/**
 * Attach to any delete form submit button.
 * Usage: <button onclick="return confirmDelete('this venue')">Delete</button>
 */
function confirmDelete(itemName) {
    return confirm('Are you sure you want to delete ' + (itemName || 'this item') + '? This action cannot be undone.');
}

/**
 * Generic confirm dialog.
 * Usage: <button onclick="return confirmAction('Cancel this booking?')">
 */
function confirmAction(message) {
    return confirm(message || 'Are you sure?');
}

// ── FORM VALIDATION ────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {

    // Highlight required fields that are empty on submit
    const forms = document.querySelectorAll('form.es-validate');
    forms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            let valid = true;
            const required = form.querySelectorAll('[required]');

            required.forEach(function (field) {
                field.style.borderColor = '';
                const msg = field.parentElement.querySelector('.field-error');
                if (msg) msg.remove();

                if (!field.value || field.value.trim() === '') {
                    valid = false;
                    field.style.borderColor = '#E53E3E';
                    const err = document.createElement('span');
                    err.className = 'field-error';
                    err.style.cssText = 'color:#E53E3E;font-size:11px;display:block;margin-top:3px;';
                    err.textContent = 'This field is required.';
                    field.parentElement.appendChild(err);
                }
            });

            // Email format check
            const emailFields = form.querySelectorAll('input[type="email"]');
            emailFields.forEach(function (field) {
                if (field.value && !isValidEmail(field.value)) {
                    valid = false;
                    field.style.borderColor = '#E53E3E';
                    const err = document.createElement('span');
                    err.className = 'field-error';
                    err.style.cssText = 'color:#E53E3E;font-size:11px;display:block;margin-top:3px;';
                    err.textContent = 'Please enter a valid email address.';
                    field.parentElement.appendChild(err);
                }
            });

            // Number min check
            const numberFields = form.querySelectorAll('input[type="number"][min]');
            numberFields.forEach(function (field) {
                const min = parseFloat(field.getAttribute('min'));
                if (field.value !== '' && parseFloat(field.value) < min) {
                    valid = false;
                    field.style.borderColor = '#E53E3E';
                }
            });

            if (!valid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = form.querySelector('[style*="E53E3E"]');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    });
});

function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// ── STAR RATING DISPLAY ────────────────────────────────────────────────────
/**
 * Converts a numeric rating (1-5) to star symbols.
 * Called on DOMContentLoaded for elements with data-rating attribute.
 */
document.addEventListener('DOMContentLoaded', function () {
    const starEls = document.querySelectorAll('[data-rating]');
    starEls.forEach(function (el) {
        const rating = parseInt(el.getAttribute('data-rating'), 10);
        el.innerHTML = buildStars(rating);
    });
});

function buildStars(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
        html += i <= rating
            ? '<span class="star filled">&#9733;</span>'
            : '<span class="star empty" style="color:#D8DEE8">&#9733;</span>';
    }
    return html;
}

// ── INTERACTIVE STAR RATING INPUT ─────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    const ratingInputs = document.querySelectorAll('.star-rating-input');
    ratingInputs.forEach(function (container) {
        const stars = container.querySelectorAll('.star-btn');
        const hiddenInput = container.querySelector('input[type="hidden"]');

        stars.forEach(function (star, index) {
            star.addEventListener('mouseenter', function () {
                highlightStars(stars, index);
            });
            star.addEventListener('mouseleave', function () {
                const current = hiddenInput ? parseInt(hiddenInput.value, 10) : 0;
                highlightStars(stars, current - 1);
            });
            star.addEventListener('click', function () {
                const value = index + 1;
                if (hiddenInput) hiddenInput.value = value;
                highlightStars(stars, index);
            });
        });
    });
});

function highlightStars(stars, upToIndex) {
    stars.forEach(function (s, i) {
        s.style.color = i <= upToIndex ? '#E8A020' : '#D8DEE8';
    });
}

// ── MODAL HELPERS ──────────────────────────────────────────────────────────
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.add('show');
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.remove('show');
}

// Close modal on overlay click
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('es-modal-overlay')) {
        e.target.classList.remove('show');
    }
});

// Close modal on Escape key
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.es-modal-overlay.show').forEach(function (m) {
            m.classList.remove('show');
        });
    }
});

// ── ACTIVE NAV ITEM ────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    const currentPath = window.location.pathname;
    const navItems = document.querySelectorAll('.es-sidebar .nav-item');
    navItems.forEach(function (item) {
        const href = item.getAttribute('href');
        if (href && currentPath.startsWith(href) && href !== '/') {
            item.classList.add('active');
        }
    });
});

// ── DATE VALIDATION HELPER ─────────────────────────────────────────────────
/**
 * Prevent selecting past dates in date inputs with class "no-past-date".
 */
document.addEventListener('DOMContentLoaded', function () {
    const today = new Date().toISOString().split('T')[0];
    document.querySelectorAll('input.no-past-date').forEach(function (input) {
        if (!input.getAttribute('min')) {
            input.setAttribute('min', today);
        }
    });
});

// ── TABLE SEARCH FILTER (client-side) ─────────────────────────────────────
/**
 * Live filter a table using a text input.
 * Usage:
 *   <input type="text" oninput="filterTable('myTable', this.value)">
 *   <table id="myTable">...</table>
 */
function filterTable(tableId, query) {
    const table = document.getElementById(tableId);
    if (!table) return;

    const rows = table.querySelectorAll('tbody tr');
    const lq = query.toLowerCase().trim();

    rows.forEach(function (row) {
        const text = row.textContent.toLowerCase();
        row.style.display = lq === '' || text.includes(lq) ? '' : 'none';
    });
}

// ── PRINT PAGE ─────────────────────────────────────────────────────────────
function printPage() {
    window.print();
}

// ── TOGGLE FORM SECTION ────────────────────────────────────────────────────
function toggleSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.style.display = section.style.display === 'none' ? 'block' : 'none';
    }
}
