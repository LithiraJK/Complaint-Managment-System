
document.addEventListener("DOMContentLoaded", () => {
    initializeModals()
})

function initializeModals() {
    const editModal = document.getElementById("editModal")
    if (editModal) {
        editModal.addEventListener("show.bs.modal", handleEditModal)
    }

    const deleteModal = document.getElementById("deleteModal")
    if (deleteModal) {
        deleteModal.addEventListener("show.bs.modal", handleDeleteModal)
    }
}

function handleEditModal(event) {
    const button = event.relatedTarget

    const complaintId = button.getAttribute("data-complaint-id")
    const title = button.getAttribute("data-complaint-title")
    const description = button.getAttribute("data-complaint-description")
    const category = button.getAttribute("data-complaint-category")
    const priority = button.getAttribute("data-complaint-priority")

    document.getElementById("editComplaintId").value = complaintId
    document.getElementById("editTitle").value = title
    document.getElementById("editDescription").value = description
    document.getElementById("editCategory").value = category
    document.getElementById("editPriority").value = priority
}

function handleDeleteModal(event) {
    const button = event.relatedTarget

    const complaintId = button.getAttribute("data-complaint-id")
    const title = button.getAttribute("data-complaint-title")

    document.getElementById("deleteComplaintId").value = complaintId
    document.getElementById("deleteComplaintTitle").textContent = title
}

function validateForm(formId) {
    const form = document.getElementById(formId)
    const inputs = form.querySelectorAll("input[required], select[required], textarea[required]")

    for (const input of inputs) {
        if (!input.value.trim()) {
            input.focus()
            return false
        }
    }
    return true
}

function showLoadingState(buttonElement, loadingText = "Processing...") {
    const originalText = buttonElement.innerHTML
    buttonElement.innerHTML = '<i class="bi bi-hourglass-split"></i> ' + loadingText
    buttonElement.disabled = true

    setTimeout(() => {
        buttonElement.innerHTML = originalText
        buttonElement.disabled = false
    }, 3000)
}
