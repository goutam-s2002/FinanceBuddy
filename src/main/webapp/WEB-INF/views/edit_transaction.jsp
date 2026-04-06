<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinanceBuddy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f5f5;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            border-radius: 16px;
            padding: 32px;
        }
        h2 {
            margin-bottom: 24px;
            color: #1a1a1a;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #f97316;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
        .cancel {
            display: block;
            text-align: center;
            margin-top: 16px;
            color: #666;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <c:set var="page" value="transactions" scope="request"/>
    <jsp:include page="navbar.jsp"/>
    
    <div class="container">
        <div class="card">
            <h2>Edit Transaction</h2>
            <form action="/transactions/edit/${transaction.id}" method="post">
                <div class="form-group">
                    <label>Amount</label>
                    <input type="number" name="amount" value="${transaction.amount}" step="0.01" required>
                </div>
                <div class="form-group">
                    <label>Type</label>
                    <select name="type" required>
                        <option value="INCOME" ${transaction.type == 'INCOME' ? 'selected' : ''}>Income</option>
                        <option value="EXPENSE" ${transaction.type == 'EXPENSE' ? 'selected' : ''}>Expense</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <input type="text" name="category" value="${transaction.category}" required>
                </div>
                <div class="form-group">
                    <label>Remark</label>
                    <textarea name="remark" rows="3">${transaction.remark}</textarea>
                </div>
                <button type="submit">Update</button>
                <a href="/transactions" class="cancel">Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>