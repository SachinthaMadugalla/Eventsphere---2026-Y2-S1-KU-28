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
        const open = sidebar.classList.toggle('open');
        document.querySelector('.sidebar-toggle')?.setAttribute('aria-expanded', String(open));
    }
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function (e) {
    const sidebar = document.querySelector('.es-sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    if (!sidebar) return;

    if (window.innerWidth <= 768) {
        if (!sidebar.contains(e.target) && !toggleBtn?.contains(e.target)) {
            sidebar.classList.remove('open');
            toggleBtn?.setAttribute('aria-expanded', 'false');
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

    // Phone inputs: keep digits only and never more than 10 of them
    document.querySelectorAll('input[data-rule="phone"]').forEach(function (field) {
        field.addEventListener('input', function () {
            const digits = field.value.replace(/\D/g, '').slice(0, 10);
            if (digits !== field.value) field.value = digits;
        });
    });

    const forms = document.querySelectorAll('form.es-validate');
    forms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            let valid = true;

            // Clear previous errors on every field in the form
            form.querySelectorAll('.field-error').forEach(function (msg) { msg.remove(); });
            form.querySelectorAll('input, select, textarea').forEach(function (field) {
                field.style.borderColor = '';
                field.removeAttribute('aria-invalid');
            });

            form.querySelectorAll('input:not([type="hidden"]):not([disabled]), select:not([disabled]), textarea:not([disabled])').forEach(function (field) {
                const error = getFieldError(field, form);
                if (error) {
                    valid = false;
                    showFieldError(field, error);
                }
            });

            if (!valid) {
                e.preventDefault();
                const firstError = form.querySelector('[aria-invalid="true"]');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus({ preventScroll: true });
                }
            }
        });
    });
});

/**
 * Returns an error message for the field, or null when it is valid.
 * Rules come from standard attributes (required, minlength, maxlength, min, max, type=email)
 * and from data-rule="phone|name|username" and data-match="<id of field to match>".
 */
function getFieldError(field, form) {
    const value = (field.value || '').trim();

    if (field.hasAttribute('required') && value === '') {
        return 'This field is required.';
    }
    if (value === '') return null; // optional field left empty

    const rule = field.getAttribute('data-rule');
    if (rule === 'phone' && !isValidPhone(value)) {
        return 'Phone number must be exactly 10 digits and start with 0 (e.g. 0771234567).';
    }
    if (rule === 'name' && !isValidPersonName(value)) {
        return 'Use 2-100 letters. Spaces, dots, apostrophes and hyphens are allowed.';
    }
    if (rule === 'username' && !isValidUsername(value)) {
        return 'Use 3-50 letters, numbers, dots, underscores or hyphens.';
    }
    if (field.type === 'email' && !isValidEmail(value)) {
        return 'Please enter a valid email address (e.g. name@example.com).';
    }

    const minLength = parseInt(field.getAttribute('minlength'), 10);
    if (!isNaN(minLength) && field.value.length < minLength) {
        return 'Must be at least ' + minLength + ' characters.';
    }
    const maxLength = parseInt(field.getAttribute('maxlength'), 10);
    if (!isNaN(maxLength) && field.value.length > maxLength) {
        return 'Must not exceed ' + maxLength + ' characters.';
    }

    if (field.type === 'number') {
        const num = parseFloat(value);
        if (isNaN(num)) return 'Please enter a valid number.';
        const min = parseFloat(field.getAttribute('min'));
        const max = parseFloat(field.getAttribute('max'));
        if (!isNaN(min) && num < min) return 'Value must be at least ' + min + '.';
        if (!isNaN(max) && num > max) return 'Value must not exceed ' + max + '.';
    }

    const matchId = field.getAttribute('data-match');
    if (matchId) {
        const other = form.querySelector('#' + matchId);
        if (other && other.value !== field.value) return 'Passwords do not match.';
    }
    return null;
}

function showFieldError(field, message) {
    field.style.borderColor = '#E53E3E';
    field.setAttribute('aria-invalid', 'true');
    const err = document.createElement('span');
    err.className = 'field-error';
    err.setAttribute('role', 'alert');
    err.style.cssText = 'color:#E53E3E;font-size:11px;display:block;margin-top:3px;';
    err.textContent = message;
    field.parentElement.appendChild(err);
}

function isValidEmail(email) {
    return /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email) && email.indexOf('..') === -1 && email.length <= 150;
}

function isValidPhone(phone) {
    return /^0\d{9}$/.test(phone);
}

function isValidPersonName(name) {
    return name.length >= 2 && name.length <= 100 && /^\p{L}[\p{L} .'-]*$/u.test(name);
}

function isValidUsername(username) {
    return /^[A-Za-z0-9._-]{3,50}$/.test(username);
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

// ── TOPBAR DATE CHIP ──────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    const chip = document.getElementById('topbar-date');
    if (chip) {
        chip.textContent = new Date().toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' });
    }
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

document.addEventListener('keydown', function (event) {
    const sidebar = document.querySelector('.es-sidebar');
    if (event.key === 'Escape' && sidebar?.classList.contains('open')) {
        sidebar.classList.remove('open');
        const toggle = document.querySelector('.sidebar-toggle');
        toggle?.setAttribute('aria-expanded', 'false');
        toggle?.focus();
    }
});

// ── SEARCHABLE SELECT (Tom Select) ─────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    // Apply searchable select to large lists (Customers, Venues, Vendors, Events, etc.)
    const searchableNames = ['customerId', 'venueId', 'vendorId', 'eventId', 'managerUserId', 'categoryId', 'resourceId', 'staffId', 'roleId'];
    
    document.querySelectorAll('select.es-select').forEach(function (selectEl) {
        if (selectEl.classList.contains('tomselected')) return;
        
        if (searchableNames.includes(selectEl.name) || selectEl.classList.contains('search-select')) {
            new TomSelect(selectEl, {
                create: false,
                placeholder: selectEl.options[0]?.text || "Select an option"
            });
        }
    });
});

// ── DARK MODE TOGGLE ───────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    const toggleBtn = document.getElementById('darkModeToggle');
    const icon = toggleBtn ? toggleBtn.querySelector('i') : null;
    
    // Check saved preference
    const isDark = localStorage.getItem('es-theme') === 'dark';
    if (isDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        if (icon) {
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        }
    }
    
    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            if (currentTheme === 'dark') {
                document.documentElement.removeAttribute('data-theme');
                localStorage.setItem('es-theme', 'light');
                icon.classList.remove('fa-sun');
                icon.classList.add('fa-moon');
            } else {
                document.documentElement.setAttribute('data-theme', 'dark');
                localStorage.setItem('es-theme', 'dark');
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
            }
        });
    }
});