<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FinanceBuddy</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Inter', sans-serif;
	background: #f5f5f5;
}

.container {
	max-width: 1000px;
	margin: 0 auto;
	padding: 24px;
}

.header {
	margin-bottom: 24px;
}

.header h1 {
	font-size: 24px;
	color: #1a1a1a;
}

.add-card, .table-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	margin-bottom: 24px;
}

.add-card h3, .table-card h3 {
	margin-bottom: 16px;
	color: #1a1a1a;
}

.add-form {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
	gap: 16px;
	align-items: end;
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.form-group label {
	font-size: 12px;
	color: #666;
}

.form-group input, .form-group select {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.btn-add {
	background: #f97316;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #eee;
}

th {
	color: #666;
	font-weight: 500;
}

.role-badge {
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 12px;
	display: inline-block;
}

.role-ADMIN {
	background: #fee2e2;
	color: #ef4444;
}

.role-ANALYST {
	background: #dbeafe;
	color: #3b82f6;
}

.role-USER {
	background: #d1fae5;
	color: #10b981;
}

.btn-edit {
	background: #3b82f6;
	color: white;
	padding: 4px 12px;
	border-radius: 6px;
	text-decoration: none;
	font-size: 12px;
}
</style>
</head>
<body>
	<c:set var="page" value="users" scope="request" />
	<jsp:include page="navbar.jsp" />

	<div class="container">
		<div class="header">
			<h1>User Management</h1>
		</div>

		<div class="add-card">
			<h3>Add New User</h3>
			<form action="/users/add" method="post" class="add-form">
				<div class="form-group">
					<label>Username</label> <input type="text" name="username" required>
				</div>
				<div class="form-group">
					<label>Email</label> <input type="email" name="email" required>
				</div>
				<div class="form-group">
					<label>Password</label> <input type="password" name="password"
						required>
				</div>
				<div class="form-group">
					<label>Role</label> <select name="role">
						<option value="USER">USER</option>
						<option value="ANALYST">ANALYST</option>
					</select>
				</div>
				<button type="submit" class="btn-add">Add User</button>
			</form>
		</div>

		<div class="table-card">
			<h3>All Users</h3>
			<table>
				<thead>
					<tr>
						<th>ID</th>
						<th>Username</th>
						<th>Email</th>
						<th>Role</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${users}" var="u">
						<tr>
							<td>${u.id}</td>
							<td>${u.username}</td>
							<td>${u.email}</td>
							<td><span class="role-badge role-${u.role}">${u.role}</span></td>
							<td>${u.status}</td>
							<td><c:if test="${u.id != sessionScope.loggedInUser.id}">
									<form action="/users/edit/${u.id}" method="post"
										style="display: inline;">
										<select name="role" onchange="this.form.submit()">
											<option value="USER" ${u.role == 'USER' ? 'selected' : ''}>USER</option>
											<option value="ANALYST"
												${u.role == 'ANALYST' ? 'selected' : ''}>ANALYST</option>
										</select> <select name="status" onchange="this.form.submit()">
											<option value="ACTIVE"
												${u.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
											<option value="INACTIVE"
												${u.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
										</select>
									</form>
								</c:if> <c:if test="${u.id == sessionScope.loggedInUser.id}">
									<span style="color: #999;">CURRENT ADMIN</span>
								</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>