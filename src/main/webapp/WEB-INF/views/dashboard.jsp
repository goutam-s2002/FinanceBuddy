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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

.filter-bar {
	background: white;
	border-radius: 12px;
	padding: 16px;
	margin-bottom: 24px;
	display: flex;
	gap: 16px;
	align-items: center;
	flex-wrap: wrap;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.filter-bar input {
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.filter-bar button {
	background: #f97316;
	color: white;
	border: none;
	padding: 10px 24px;
	border-radius: 8px;
	cursor: pointer;
}

.filter-bar a {
	color: #666;
	text-decoration: none;
}

.stats {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	margin-bottom: 32px;
}

.stat-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.stat-label {
	font-size: 14px;
	color: #666;
	margin-bottom: 8px;
}

.stat-value {
	font-size: 32px;
	font-weight: 700;
}

.income {
	color: #10b981;
}

.expense {
	color: #ef4444;
}

.net {
	color: #f97316;
}

.chart-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
	margin-bottom: 32px;
}

.chart-card {
	background: white;
	border-radius: 16px;
	padding: 20px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.chart-card h3 {
	margin-bottom: 16px;
	color: #1a1a1a;
	font-size: 16px;
}

canvas {
	max-height: 280px;
	width: 100%;
}

.recent-card {
	background: white;
	border-radius: 16px;
	padding: 24px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.recent-card h3 {
	margin-bottom: 20px;
	color: #1a1a1a;
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

.income-text {
	color: #10b981;
	font-weight: 600;
}

.expense-text {
	color: #ef4444;
	font-weight: 600;
}

.no-data {
	text-align: center;
	padding: 40px;
	color: #999;
}

@media ( max-width : 768px) {
	.stats {
		grid-template-columns: 1fr;
	}
	.chart-row {
		grid-template-columns: 1fr;
	}
}
</style>
</head>
<body>
	<c:set var="page" value="dashboard" scope="request" />
	<jsp:include page="navbar.jsp" />

	<div class="container">
		<!-- Filter Bar -->
		<div class="filter-bar">
			<form action="/dashboard" method="get"
				style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
				<input type="date" name="startDate" > <input
					type="date" name="endDate" >
				<button type="submit">
					Submit
				</button>
				
			</form>
		</div>

		<!-- Stats Cards -->
		<div class="stats">
			<div class="stat-card">
				<div class="stat-label">Total Income</div>
				<div class="stat-value income">&#8377; ${totalIncome}</div>
			</div>
			<div class="stat-card">
				<div class="stat-label">Total Expense</div>
				<div class="stat-value expense">&#8377; ${totalExpense}</div>
			</div>
			<div class="stat-card">
				<div class="stat-label">Net Balance</div>
				<div class="stat-value net">&#8377; ${netBalance}</div>
			</div>
		</div>

		<!-- Charts Row: Bar Chart + Pie Chart -->
		<div class="chart-row">
			<div class="chart-card">
				<h3>
					<i class="fas fa-chart-bar"></i> Income vs Expense
				</h3>
				<canvas id="barChart"></canvas>
			</div>
			<div class="chart-card">
				<h3>
					<i class="fas fa-chart-pie"></i> Expense Distribution
				</h3>
				<canvas id="pieChart"></canvas>
			</div>
		</div>

		<!-- Line Chart -->
		<div class="chart-card" style="margin-bottom: 32px;">
			<h3>
				<i class="fas fa-chart-line"></i> Monthly Trends
			</h3>
			<canvas id="lineChart"></canvas>
		</div>

		<!-- Recent Transactions -->
		<div class="recent-card">
			<h3>
				<i class="fas fa-clock"></i> Recent Transactions
			</h3>
			<c:choose>
				<c:when test="${not empty recent}">
					<table>
						<thead>
							<tr>
								<th>Date</th>
								<th>Category</th>
								<th>Type</th>
								<th>Amount</th>
								<th>Remark</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${recent}" var="t">
								<tr>
									<td>${t.date}</td>
									<td>${t.category}</td>
									<td
										class="${t.type == 'INCOME' ? 'income-text' : 'expense-text'}">${t.type}</td>
									<td
										class="${t.type == 'INCOME' ? 'income-text' : 'expense-text'}">&#8377;
										${t.amount}</td>
									<td>${t.remark}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<div class="no-data">No transactions found</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<script>
    // JSON data from controller
    const categories = ${categoriesJson};
    const incomeData = ${incomeDataJson};
    const expenseData = ${expenseDataJson};
    const pieLabels = ${pieLabelsJson};
    const pieValues = ${pieValuesJson};
    const months = ${monthsJson};
    const monthIncome = ${monthIncomeJson};
    const monthExpense = ${monthExpenseJson};
    
    console.log("Categories:", categories);
    console.log("Pie Labels:", pieLabels);
    
    // Bar Chart
    const barCtx = document.getElementById('barChart').getContext('2d');
    new Chart(barCtx, {
        type: 'bar',
        data: {
            labels: categories,
            datasets: [
                { label: 'Income', data: incomeData, backgroundColor: '#10b981', borderRadius: 8 },
                { label: 'Expense', data: expenseData, backgroundColor: '#ef4444', borderRadius: 8 }
            ]
        },
        options: { responsive: true }
    });
    
    // Pie Chart
    if(pieLabels.length > 0) {
        const pieCtx = document.getElementById('pieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: pieLabels,
                datasets: [{ data: pieValues, backgroundColor: ['#f97316', '#10b981', '#3b82f6', '#8b5cf6'] }]
            },
            options: { responsive: true }
        });
    }
    
    // Line Chart
    const lineCtx = document.getElementById('lineChart').getContext('2d');
    new Chart(lineCtx, {
        type: 'line',
        data: {
            labels: months,
            datasets: [
                { label: 'Income', data: monthIncome, borderColor: '#10b981', fill: true, tension: 0.4 },
                { label: 'Expense', data: monthExpense, borderColor: '#ef4444', fill: true, tension: 0.4 }
            ]
        },
        options: { responsive: true }
    });
</script>
</body>
</html>