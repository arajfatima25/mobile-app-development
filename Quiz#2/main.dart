<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Student Manager - Quiz 2</title>
  <style>
    /* --- Global Styles --- */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    body {
      background: linear-gradient(135deg, #6c63ff, #42a5f5);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding: 40px 20px;
    }

    .container {
      background: #fff;
      width: 100%;
      max-width: 800px;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }

    h1 {
      text-align: center;
      color: #333;
      margin-bottom: 25px;
      font-size: 28px;
    }

    .form {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 20px;
      justify-content: center;
    }

    .form input {
      padding: 10px 15px;
      border: 1px solid #ccc;
      border-radius: 8px;
      width: calc(50% - 10px);
      font-size: 14px;
      outline: none;
      transition: 0.2s;
    }

    .form input:focus {
      border-color: #6c63ff;
    }

    .form button {
      background: #6c63ff;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 15px;
      cursor: pointer;
      transition: 0.3s;
    }

    .form button:hover {
      background: #574bfa;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }

    th, td {
      padding: 12px;
      border-bottom: 1px solid #ddd;
      text-align: center;
      font-size: 15px;
    }

    th {
      background: #6c63ff;
      color: white;
    }

    tr:hover {
      background: #f4f4f9;
    }

    .actions button {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 16px;
      padding: 5px 10px;
      border-radius: 6px;
      transition: 0.2s;
    }

    .actions .edit {
      color: #42a5f5;
    }

    .actions .delete {
      color: #e53935;
    }

    .actions button:hover {
      transform: scale(1.1);
      background: #f1f1f1;
    }

    .no-records {
      text-align: center;
      padding: 20px;
      color: #777;
      font-style: italic;
    }

    @media (max-width: 600px) {
      .form input {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Student Manager (Quiz 2)</h1>

    <div class="form">
      <input type="text" id="name" placeholder="Enter Name" />
      <input type="email" id="email" placeholder="Enter Email" />
      <input type="number" id="age" placeholder="Enter Age" />
      <input type="url" id="image" placeholder="Image URL (optional)" />
      <button id="addBtn">Add</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>Image</th>
          <th>Name</th>
          <th>Email</th>
          <th>Age</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody id="studentTable"></tbody>
    </table>
  </div>

  <script>
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const ageInput = document.getElementById('age');
    const imageInput = document.getElementById('image');
    const addBtn = document.getElementById('addBtn');
    const tableBody = document.getElementById('studentTable');

    let editIndex = null;
    let students = JSON.parse(localStorage.getItem('students')) || [];

    function renderTable() {
      tableBody.innerHTML = '';
      if (students.length === 0) {
        tableBody.innerHTML = `<tr><td colspan="5" class="no-records">No records found.</td></tr>`;
        return;
      }

      students.forEach((s, index) => {
        tableBody.innerHTML += `
          <tr>
            <td><img src="${s.image || 'https://via.placeholder.com/60'}" width="50" height="50" style="border-radius:8px;object-fit:cover;"></td>
            <td>${s.name}</td>
            <td>${s.email}</td>
            <td>${s.age}</td>
            <td class="actions">
              <button class="edit" onclick="editStudent(${index})">✏️</button>
              <button class="delete" onclick="deleteStudent(${index})">🗑️</button>
            </td>
          </tr>
        `;
      });
    }

    function clearForm() {
      nameInput.value = '';
      emailInput.value = '';
      ageInput.value = '';
      imageInput.value = '';
      editIndex = null;
      addBtn.textContent = 'Add';
    }

    addBtn.addEventListener('click', () => {
      const name = nameInput.value.trim();
      const email = emailInput.value.trim();
      const age = ageInput.value.trim();
      const image = imageInput.value.trim();

      if (!name || !email || !age) {
        alert('Please fill in all required fields!');
        return;
      }

      const student = { name, email, age, image };

      if (editIndex !== null) {
        students[editIndex] = student;
        addBtn.textContent = 'Add';
      } else {
        students.push(student);
      }

      localStorage.setItem('students', JSON.stringify(students));
      renderTable();
      clearForm();
    });

    function editStudent(index) {
      const s = students[index];
      nameInput.value = s.name;
      emailInput.value = s.email;
      ageInput.value = s.age;
      imageInput.value = s.image;
      editIndex = index;
      addBtn.textContent = 'Update';
    }

    function deleteStudent(index) {
      if (confirm('Delete this record?')) {
        students.splice(index, 1);
        localStorage.setItem('students', JSON.stringify(students));
        renderTable();
      }
    }

    // Initial render
    renderTable();
  </script>
</body>
</html>
