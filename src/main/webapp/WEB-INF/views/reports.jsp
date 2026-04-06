<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reports - FinanceBuddy</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
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

/* Header */
.header {
	margin-bottom: 28px;
}

.header h1 {
	font-size: 24px;
	font-weight: 700;
	color: #1a1a1a;
}

.header p {
	color: #666;
	font-size: 14px;
	margin-top: 6px;
}

/* Filter Bar */
.filter-bar {
	background: white;
	border-radius: 16px;
	padding: 20px;
	margin-bottom: 24px;
	border: 1px solid #eee;
}

.filter-form {
	display: flex;
	gap: 12px;
	flex-wrap: wrap;
	align-items: center;
}

.filter-form input {
	padding: 10px 16px;
	border-radius: 10px;
	border: 1px solid #ddd;
	font-family: 'Inter', sans-serif;
}

.filter-form button {
	background: #f97316;
	color: white;
	border: none;
	padding: 10px 24px;
	border-radius: 10px;
	cursor: pointer;
	font-weight: 500;
}

.filter-form button:hover {
	background: #ea580c;
}

/* Report Grid */
.report-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 24px;
	margin-bottom: 24px;
}

.report-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	border: 1px solid #eee;
}

.report-card h3 {
	margin-bottom: 20px;
	color: #1a1a1a;
	font-size: 16px;
	font-weight: 600;
}

.report-card h3 i {
	color: #f97316;
	margin-right: 8px;
}

/* Category List */
.category-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.category-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 8px 0;
	border-bottom: 1px solid #f0f0f0;
}

.category-name {
	width: 100px;
	font-weight: 500;
	color: #333;
}

.progress-bar {
	flex: 1;
	margin: 0 16px;
	height: 8px;
	background: #e8e8e8;
	border-radius: 4px;
	overflow: hidden;
}

.progress-fill {
	height: 100%;
	border-radius: 4px;
}

.progress-fill.income {
	background: #10b981;
}

.progress-fill.expense {
	background: #ef4444;
}

.category-amount {
	font-weight: 600;
	color: #1a1a1a;
	min-width: 80px;
	text-align: right;
}

.category-percent {
	min-width: 50px;
	text-align: right;
	color: #666;
	font-size: 13px;
}

/* Monthly Summary Table */
.summary-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	border: 1px solid #eee;
	margin-bottom: 24px;
}

.summary-card h3 {
	margin-bottom: 20px;
	color: #1a1a1a;
	font-size: 16px;
	font-weight: 600;
}

.summary-card h3 i {
	color: #f97316;
	margin-right: 8px;
}

.table-wrapper {
	overflow-x: auto;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	text-align: left;
	padding: 12px;
	background: #f8f8f8;
	color: #666;
	font-weight: 500;
	font-size: 13px;
	border-radius: 8px;
}

td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	color: #333;
}

.income-text {
	color: #10b981;
	font-weight: 600;
}

.expense-text {
	color: #ef4444;
	font-weight: 600;
}

/* Export Button */
.btn-export {
	background: #f97316;
	color: white;
	border: none;
	padding: 12px 24px;
	border-radius: 10px;
	cursor: pointer;
	font-weight: 600;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.btn-export:hover {
	background: #ea580c;
}

/* No Data */
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
	.report-grid {
		grid-template-columns: 1fr;
	}
	.category-row {
		flex-wrap: wrap;
		gap: 8px;
	}
	.category-name {
		width: 100%;
	}
	.progress-bar {
		order: 1;
		width: 100%;
		margin: 0;
	}
}
</style>
</head>
<body>
	<c:set var="page" value="reports" scope="request" />
	<jsp:include page="navbar.jsp" />

	<div class="container">
		<div class="header">
			<h1>
				<i class="fas fa-file-alt"></i> Financial
				Reports
			</h1>
			<p>Detailed analysis of your income and expenses</p>
		</div>

		<!-- Filter Bar -->
		<div class="filter-bar">
			<form action="/reports" method="get" class="filter-form">
				<input type="date" name="startDate"> 
				<input type="date" name="endDate">
				<button type="submit">
					Submit
				</button>
			</form>
		</div>

		<!-- Charts Grid -->
		<div class="report-grid">
			<!-- Income by Category -->
			<div class="report-card">
				<h3>
					<i class="fas fa-arrow-up"></i> Income by Category
				</h3>
				<c:choose>
					<c:when test="${not empty categoryIncome}">
						<div class="category-list">
							<c:forEach items="${categoryIncome}" var="entry">
								<div class="category-row">
									<span class="category-name">${entry.key}</span>
									<div class="progress-bar">
										<div class="progress-fill income"
											style="width: ${entry.value / totalIncome * 100}%"></div>
									</div>
									<span class="category-amount">&#8377; ${entry.value}</span>
									<span class="category-percent">${Math.round(entry.value / totalIncome * 100)}%</span>
								</div>
							</c:forEach>
						</div>
					</c:when>
					<c:otherwise>
						<div class="no-data">No income data available</div>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- Expenses by Category -->
			<div class="report-card">
				<h3>
					<i class="fas fa-arrow-down"></i> Expenses by Category
				</h3>
				<c:choose>
					<c:when test="${not empty categoryExpense}">
						<div class="category-list">
							<c:forEach items="${categoryExpense}" var="entry">
								<div class="category-row">
									<span class="category-name">${entry.key}</span>
									<div class="progress-bar">
										<div class="progress-fill expense"
											style="width: ${entry.value / totalExpense * 100}%"></div>
									</div>
									<span class="category-amount">&#8377; ${entry.value}</span>
									<span class="category-percent">${Math.round(entry.value / totalExpense * 100)}%</span>
								</div>
							</c:forEach>
						</div>
					</c:when>
					<c:otherwise>
						<div class="no-data">No expense data available</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<!-- Monthly Summary -->
		<div class="summary-card">
			<h3>
				<i class="fas fa-calendar-alt"></i> Monthly Summary
			</h3>
			<c:choose>
				<c:when test="${not empty monthlyTrends}">
					<div class="table-wrapper">
						<table>
							<thead>
								<tr>
									<th>Month</th>
									<th>Income</th>
									<th>Expense</th>
									<th>Net</th>
									<th>Savings Rate</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${monthlyTrends}" var="m">
									<tr>
										<td>${m.month}</td>
										<td class="income-text">&#8377; ${m.income}</td>
										<td class="expense-text">&#8377; ${m.expense}</td>
										<td>&#8377; ${m.net}</td>
										<td>${Math.round(m.net / m.income * 100)}%</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</c:when>
				<c:otherwise>
					<div class="no-data">No monthly data available</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- Export Button -->
		<button class="btn-export" onclick="printReport()">
			<i class="fas fa-download"></i> Export Report (PDF)
		</button>
	</div>
	<script>
function printReport() {

    const navbar = document.querySelector('.navbar');
    const filterBar = document.querySelector('.filter-bar');
    const exportBtn = document.querySelector('.btn-export');
    
    if (navbar) navbar.style.display = 'none';
    if (filterBar) filterBar.style.display = 'none';
    if (exportBtn) exportBtn.style.display = 'none';

    window.print();
    
    if (navbar) navbar.style.display = 'block';
    if (filterBar) filterBar.style.display = 'flex';
    if (exportBtn) exportBtn.style.display = 'inline-flex';
}
</script>
</body>
</html>