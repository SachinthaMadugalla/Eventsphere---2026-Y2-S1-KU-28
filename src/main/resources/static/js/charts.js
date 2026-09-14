/**
 * EventSphere – Chart Utilities
 * SE2030 | Group 2026-Y2-S1-KU-28
 *
 * Wrappers around Chart.js for consistent chart styling.
 * Requires Chart.js loaded from CDN in the JSP page.
 */

/**
 * Creates a doughnut chart showing event counts by status.
 *
 * @param {string} canvasId  - ID of the <canvas> element
 * @param {Array}  labels    - Status label strings
 * @param {Array}  data      - Count values matching labels
 */
function createEventStatusChart(canvasId, labels, data) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    const colors = {
        'Requested':   '#3182CE',
        'Pending':     '#E8A020',
        'Confirmed':   '#38A169',
        'Planning':    '#805AD5',
        'In Progress': '#2C3E6B',
        'Completed':   '#276749',
        'Cancelled':   '#E53E3E'
    };

    const backgroundColors = labels.map(function (l) {
        return colors[l] || '#A0AEC0';
    });

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: backgroundColors,
                borderWidth: 2,
                borderColor: '#FFFFFF'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        font: { size: 12, family: 'Segoe UI' },
                        color: '#4A5568',
                        padding: 16
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function (ctx) {
                            const total = ctx.dataset.data.reduce(function (a, b) { return a + b; }, 0);
                            const pct   = total > 0 ? Math.round((ctx.parsed / total) * 100) : 0;
                            return ' ' + ctx.label + ': ' + ctx.parsed + ' (' + pct + '%)';
                        }
                    }
                }
            },
            cutout: '60%'
        }
    });
}

/**
 * Creates a bar chart showing event counts per month.
 *
 * @param {string} canvasId   - ID of the <canvas> element
 * @param {Array}  monthNums  - Month numbers (1-12)
 * @param {Array}  counts     - Corresponding event counts
 */
function createMonthlyBarChart(canvasId, monthNums, counts) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Build full 12-month dataset (fill missing months with 0)
    const fullLabels = monthNames;
    const fullData   = new Array(12).fill(0);
    if (monthNums && counts) {
        for (let i = 0; i < monthNums.length; i++) {
            const idx = monthNums[i] - 1;
            if (idx >= 0 && idx < 12) fullData[idx] = counts[i];
        }
    }

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: fullLabels,
            datasets: [{
                label: 'Events',
                data: fullData,
                backgroundColor: '#2C3E6B',
                borderRadius: 4,
                borderSkipped: false,
                hoverBackgroundColor: '#E8A020'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (ctx) {
                            return ' ' + ctx.parsed.y + ' event(s)';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: { size: 11 },
                        color: '#718096'
                    },
                    grid: { color: '#EEF1F6' }
                },
                x: {
                    ticks: {
                        font: { size: 11 },
                        color: '#718096'
                    },
                    grid: { display: false }
                }
            }
        }
    });
}

/**
 * Creates a horizontal bar chart for finance summary.
 *
 * @param {string} canvasId  - ID of the <canvas> element
 * @param {number} revenue   - Total invoice revenue
 * @param {number} collected - Total collected payments
 * @param {number} outstanding - Outstanding balance
 */
function createFinanceChart(canvasId, revenue, collected, outstanding) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Total Revenue', 'Collected', 'Outstanding'],
            datasets: [{
                data: [revenue, collected, outstanding],
                backgroundColor: ['#2C3E6B', '#38A169', '#E8A020'],
                borderRadius: 6,
                borderSkipped: false
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (ctx) {
                            return ' LKR ' + ctx.parsed.x.toLocaleString('en-LK');
                        }
                    }
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        font: { size: 11 },
                        color: '#718096',
                        callback: function (val) {
                            return 'LKR ' + (val / 1000).toFixed(0) + 'K';
                        }
                    },
                    grid: { color: '#EEF1F6' }
                },
                y: {
                    ticks: { font: { size: 12 }, color: '#4A5568' },
                    grid: { display: false }
                }
            }
        }
    });
}

/**
 * Creates a small task status pie chart.
 *
 * @param {string} canvasId
 * @param {number} pending
 * @param {number} inProgress
 * @param {number} completed
 * @param {number} overdue
 */
function createTaskStatusChart(canvasId, pending, inProgress, completed, overdue) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: ['Not Started', 'In Progress', 'Completed', 'Overdue'],
            datasets: [{
                data: [pending, inProgress, completed, overdue],
                backgroundColor: ['#A0AEC0', '#3182CE', '#38A169', '#E53E3E'],
                borderWidth: 2,
                borderColor: '#FFFFFF'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        font: { size: 11, family: 'Segoe UI' },
                        color: '#4A5568',
                        padding: 12
                    }
                }
            }
        }
    });
}
