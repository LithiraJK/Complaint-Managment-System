    function openEditModal(id, title, description, category, priority, status, adminRemarks) {
    document.getElementById('editComplaintId').value = id;
    document.getElementById('editTitle').value = title;
    document.getElementById('editDescription').value = description;
    document.getElementById('editCategory').value = category;
    document.getElementById('editPriority').value = priority;
    document.getElementById('editStatus').value = status;
    document.getElementById('editAdminRemark').value = adminRemarks;
}

    function openDeleteModal(id, title, submittedBy) {
    document.getElementById('deleteComplaintId').value = id;
    document.getElementById('deleteTitle').textContent = title;
    document.getElementById('deleteSubmittedBy').textContent = submittedBy;
}

    document.getElementById('editForm').addEventListener('submit', function(e) {
    const status = document.getElementById('editStatus').value;
    if (!status) {
    e.preventDefault();
    alert('Please select a status for the complaint.');
    return false;
}
});