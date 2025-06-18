document.getElementById('editModal').addEventListener('show.bs.modal', function (event) {
    const button = event.relatedTarget;
    const complaintId = button.getAttribute('data-complaint-id');
    const title = button.getAttribute('data-complaint-title');
    const description = button.getAttribute('data-complaint-description');
    const category = button.getAttribute('data-complaint-category');
    const priority = button.getAttribute('data-complaint-priority');

    document.getElementById('editComplaintId').value = complaintId;
    document.getElementById('editTitle').value = title;
    document.getElementById('editDescription').value = description;
    document.getElementById('editCategory').value = category;
    document.getElementById('editPriority').value = priority;
});

document.getElementById('deleteModal').addEventListener('show.bs.modal', function (event) {
    const button = event.relatedTarget;
    const complaintId = button.getAttribute('data-complaint-id');
    const title = button.getAttribute('data-complaint-title');

    document.getElementById('deleteComplaintId').value = complaintId;
    document.getElementById('deleteComplaintTitle').textContent = title;
});