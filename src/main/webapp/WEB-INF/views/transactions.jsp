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
	max-width: 1200px;
	margin: 0 auto;
	padding: 24px;
}

.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
	flex-wrap: wrap;
	gap: 16px;
}

.header h1 {
	font-size: 24px;
	color: #1a1a1a;
}

.btn-add {
	background: #f97316;
	color: white;
	padding: 10px 20px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 500;
	transition: background 0.3s;
}

.btn-add:hover {
	background: #ea580c;
}

/* ========== FILTER BAR CSS ========== */
.filter-bar {
	background: white;
	border-radius: 16px;
	padding: 20px;
	margin-bottom: 24px;
	border: 1px solid #eee;
	box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.filter-form {
	display: flex;
	gap: 12px;
	flex-wrap: wrap;
	align-items: center;
}

.filter-form input, .filter-form select {
	padding: 10px 14px;
	border: 1px solid #ddd;
	border-radius: 10px;
	font-family: 'Inter', sans-serif;
	font-size: 14px;
	min-width: 140px;
	background: white;
}

.filter-form input:focus, .filter-form select:focus {
	outline: none;
	border-color: #f97316;
}

.filter-form button {
	background: #f97316;
	color: white;
	border: none;
	padding: 10px 24px;
	border-radius: 10px;
	cursor: pointer;
	font-weight: 500;
	font-family: 'Inter', sans-serif;
	transition: background 0.3s;
}

.filter-form button:hover {
	background: #ea580c;
}

.filter-form a {
	color: #666;
	text-decoration: none;
	font-size: 14px;
	padding: 8px 12px;
	border-radius: 8px;
	transition: all 0.3s;
}

.filter-form a:hover {
	background: #f0f0f0;
	color: #333;
}

/* ========== TABLE CSS ========== */
.table-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	overflow-x: auto;
}

table {
	width: 100%;
	border-collapse: collapse;
	min-width: 600px;
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

.income-text {
	color: #10b981;
	font-weight: 600;
}

.expense-text {
	color: #ef4444;
	font-weight: 600;
}

.btn-edit {
	background: #3b82f6;
	color: white;
	padding: 4px 12px;
	border-radius: 6px;
	text-decoration: none;
	font-size: 12px;
	margin-right: 6px;
	display: inline-block;
}

.btn-edit:hover {
	background: #2563eb;
}

.btn-delete {
	background: #ef4444;
	color: white;
	padding: 4px 12px;
	border-radius: 6px;
	text-decoration: none;
	font-size: 12px;
	display: inline-block;
}

.btn-delete:hover {
	background: #dc2626;
}

.no-data {
	text-align: center;
	padding: 40px;
	color: #999;
}

/* Responsive */
@media (max-width: 768px) {
	.container {
		padding: 16px;
	}
	.filter-form input, .filter-form select {
		width: 100%;
		min-width: auto;
	}
	.filter-form {
		flex-direction: column;
	}
	.filter-form button, .filter-form a {
		width: 100%;
		text-align: center;
	}
}
</style>
</head>
<body>
	<c:set var="page" value="transactions" scope="request" />
	<jsp:include page="navbar.jsp" />

	<div class="container">
		<div class="header">
			<h1>
				<i class="fas fa-exchange-alt"></i> Transactions
			</h1>
			<a href="/transactions/add" class="btn-add"><i
				class="fas fa-plus"></i> Add Transaction</a>
		</div>
		
		<!-- Filter Bar -->
		<div class="filter-bar">
			<form action="/transactions" method="get" class="filter-form">
				<input type="text" name="category" placeholder="Category" value="${param.category}">
				<select name="type">
					<option value="">All Types</option>
					<option value="INCOME" ${param.type == 'INCOME' ? 'selected' : ''}>Income</option>
					<option value="EXPENSE" ${param.type == 'EXPENSE' ? 'selected' : ''}>Expense</option>
				</select>
				<input type="date" name="startDate" value="${param.startDate}">
				<input type="date" name="endDate" value="${param.endDate}">
				<button type="submit"><i class="fas fa-search"></i> Search</button>
				
			</form>
		</div>

		<div class="table-card">
			<c:choose>
				<c:when test="${not empty transactions}">
					<table>
						<thead>
							<tr>
								<th>Date</th>
								<th>Category</th>
								<th>Type</th>
								<th>Amount</th>
								<th>Remark</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${transactions}" var="t">
								<tr>
									<td>${t.date}</td>
									<td>${t.category}</td>
									<td class="${t.type == 'INCOME' ? 'income-text' : 'expense-text'}">${t.type}</td>
									<td class="${t.type == 'INCOME' ? 'income-text' : 'expense-text'}">&#8377; ${t.amount}</td>
									<td>${t.remark != null ? t.remark : '-'}</td>
									<td>
										<a href="/transactions/edit/${t.id}" class="btn-edit"><i class="fas fa-edit"></i> Edit</a>
										<c:if test="${user.role == 'ADMIN' or (user.role == 'USER' and t.createdBy == user.id)}">
											<a href="/transactions/delete/${t.id}" class="btn-delete"
												onclick="return confirm('Are you sure you want to delete this transaction?')">
												<i class="fas fa-trash"></i> Delete
											</a>
										</c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<div class="no-data">
						<i class="fas fa-inbox" style="font-size: 48px; color: #ccc; margin-bottom: 16px; display: block;"></i>
						<p>No transactions found. Click "Add Transaction" to create one.</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</body>
</html>