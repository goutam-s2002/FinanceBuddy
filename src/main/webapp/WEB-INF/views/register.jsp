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
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 20px;
}

.card {
	background: white;
	border-radius: 16px;
	padding: 40px;
	width: 100%;
	max-width: 400px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

h1 {
	font-size: 28px;
	font-weight: 700;
	color: #1a1a1a;
	margin-bottom: 8px;
}

.subtitle {
	color: #666;
	margin-bottom: 32px;
	font-size: 14px;
}

.input-group {
	margin-bottom: 20px;
}

input {
	width: 100%;
	padding: 14px 16px;
	border: 1px solid #ddd;
	border-radius: 10px;
	font-size: 14px;
	font-family: 'Inter', sans-serif;
}

input:focus {
	outline: none;
	border-color: #f97316;
}

button {
	width: 100%;
	padding: 14px;
	background: #f97316;
	color: white;
	border: none;
	border-radius: 10px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
}

.login-link {
	text-align: center;
	margin-top: 24px;
	font-size: 14px;
	color: #666;
}

.login-link a {
	color: #f97316;
	text-decoration: none;
}

.error {
	background: #fee2e2;
	color: #ef4444;
	padding: 12px;
	border-radius: 10px;
	margin-bottom: 20px;
}

.password-wrapper {
	position: relative;
	display: flex;
	align-items: center;
}

.password-wrapper input {
	width: 100%;
	padding: 14px 45px 14px 16px;
	border: 1px solid #ddd;
	border-radius: 10px;
	font-size: 14px;
	font-family: 'Inter', sans-serif;
}

.password-wrapper input:focus {
	outline: none;
	border-color: #f97316;
}

.toggle-password {
	position: absolute;
	right: 15px;
	cursor: pointer;
	color: #999;
	font-size: 16px;
}

.toggle-password:hover {
	color: #f97316;
}
</style>
</head>
<body>
	<div class="card">
		<h1>Create account</h1>
		<p class="subtitle">Join FinanceBuddy today</p>

		<c:if test="${not empty error}">
			<div class="error">
				<i class="fas fa-exclamation-triangle"></i> ${error}
			</div>
		</c:if>

		<form action="/register" method="post">
			<div class="input-group">
				<input type="text" name="username" placeholder="Username" required>
			</div>
			<div class="input-group">
				<input type="email" name="email" placeholder="Email" required>
			</div>
			<div class="input-group">
				<div class="password-wrapper">
					<input type="password" name="password" id="password"
						placeholder="Create a password" required> <i
						class="fas fa-eye toggle-password" id="togglePassword"></i>
				</div>
			</div>
			<button type="submit">Create account</button>
		</form>

		<div class="login-link">
			Already have an account? <a href="/login">Sign in</a>
		</div>
	</div>
	<script>
		const togglePassword = document.getElementById('togglePassword');
		const password = document.getElementById('password');

		togglePassword.addEventListener('click', function() {
			// Toggle password type
			const type = password.getAttribute('type') === 'password' ? 'text'
					: 'password';
			password.setAttribute('type', type);

			// Toggle eye icon
			this.classList.toggle('fa-eye');
			this.classList.toggle('fa-eye-slash');
		});
	</script>
</body>
</html>