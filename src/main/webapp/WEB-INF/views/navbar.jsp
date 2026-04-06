<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<style>
.navbar {
	background: white;
	padding: 16px 32px;
	border-bottom: 1px solid #eee;
	position: sticky;
	top: 0;
	z-index: 100;
}

.nav-container {
	max-width: 1200px;
	margin: 0 auto;
	display: flex;
	justify-content: space-between;
	align-items: center;
	flex-wrap: wrap;
	gap: 16px;
}

.logo {
	font-size: 20px;
	font-weight: 700;
	color: #f97316;
	text-decoration: none;
}

.nav-links {
	display: flex;
	gap: 24px;
	align-items: center;
	flex-wrap: wrap;
}

.nav-links a {
	text-decoration: none;
	color: #333;
	font-weight: 500;
	padding: 8px 0;
	transition: color 0.3s;
}

.nav-links a:hover {
	color: #f97316;
}

.nav-links a.active {
	color: #f97316;
	border-bottom: 2px solid #f97316;
}

.user-info {
	display: flex;
	align-items: center;
	gap: 16px;
}

.user-name {
	font-weight: 600;
	color: #1a1a1a;
}

.user-role {
	font-size: 12px;
	color: #666;
	background: #f0f0f0;
	padding: 4px 10px;
	border-radius: 20px;
}

.logout-btn {
	background: none;
	text-decoration:none;
	border: 1px solid #ddd;
	padding: 6px 16px;
	border-radius: 8px;
	cursor: pointer;
	color: #666;
	transition: all 0.3s;
}

.logout-btn:hover {
	background: #fee2e2;
	color: #ef4444;
	border-color: #fee2e2;
}

@media ( max-width : 768px) {
	.navbar {
		padding: 16px;
	}
	.nav-container {
		flex-direction: column;
	}
	.nav-links {
		justify-content: center;
	}
}
</style>

<div class="navbar">
	<div class="nav-container">
		<a href="/dashboard" class="logo">FinanceBuddy</a>
		<div class="nav-links">
			<a href="/dashboard" class="${page == 'dashboard' ? 'active' : ''}">Dashboard</a>
			<a href="/transactions"
				class="${page == 'transactions' ? 'active' : ''}">Transactions</a>
			<c:if test="${user.role == 'ADMIN' or user.role == 'ANALYST'}">
				<a href="/reports" class="${page == 'reports' ? 'active' : ''}">Report</a>
			</c:if>
			<c:if test="${user.role == 'ADMIN'}">
				<a href="/users" class="${page == 'users' ? 'active' : ''}">Users</a>
			</c:if>
		</div>
		<div class="user-info">
			<div>
				<div class="user-name">${user.username}</div>
				<div class="user-role">${user.role}</div>
			</div>
			<a href="/logout" class="logout-btn">Logout</a>
		</div>
	</div>
</div>