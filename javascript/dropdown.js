const editButton = document.getElementById("edit_button");
editButton.addEventListener("click", enableDropdown);

// enable dropdown menu (disabled by default)
function enableDropdown() {
    const selectElement = document.getElementById("status");
    selectElement.disabled = false;
    updateButtonText();
}

// update button text
function updateButtonText() {
    const editButton = document.getElementById("edit_button");
    editButton.innerHTML = "<i class='bi bi-check2'></i>"
    editButton.addEventListener("click", saveChanges);
}

// save changes and revert to the initial edit logo
function saveChanges() {
    const selectElement = document.getElementById("status");
    selectElement.disabled = true;
    editButton.innerHTML = "<i class='bi bi-pencil-square'></i>";
    editButton.removeEventListener("click", saveChanges);
}