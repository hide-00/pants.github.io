<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />
	<c:set var="productCode" value="${param.productCode}" />
	<c:set var="formjsp" value="${param.jspCode}" />

	<sql:query var="rs">
		SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
		FROM PRODUCT_INFO WHERE PRODUCT_CODE=? ORDER BY PRODUCT_CODE;
		<sql:param value="${productCode}" />
	</sql:query>
	<c:set var="row" value="${rs.rows[0]}" />

	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
			<TITLE>衣料品販売</TITLE>

			<STYLE type="text/css">
			body {background-color:#696969;}
			img {vertical-align: middle;}
			.register { width:50%; float:left; font-family:serif;}
			.login { width:50%; float:left; font-family:serif;}
			.row{position: relative; margin : 20px; font-family:serif;
				width:300px; height: 350px; float:left; border:1px solid #ff6a00;}
				.row a{display:block; position: absolute;
					top:0; left: 0;
					width: 100%; height: 100%;}
					.row:hover{	color: #ffffff;	background-color: #a9a9a9;}
					.detail{padding-left: 40px ; text-align:left;}
					.header img{width: 100%;}
					</style>
				</head>
				<BODY>
					<p class="header">
						<img src="image/top.jpg" alt="トップ画像"/>
					</p>
					<center>
						<div class="login">
							<c:choose>
								<c:when test="${!empty productCode}"><%--商品詳細から--%>
								<h2>ログイン</h2><br>
								<FORM action="login2.jsp" method="POST">
									<input type="hidden" name="jspCode" value="${formjsp}" />
									<input type="hidden" name="hiddenCode" value="${productCode}" />
									ユーザー名<BR>
									<INPUT TYPE="text" NAME="customerName" SIZE="30" MAXLENGTH="50"><BR><BR>
									パスワード<BR>
									<INPUT TYPE="password" NAME="password" SIZE="30" MAXLENGTH="10"><BR><BR>
									<INPUT TYPE="submit" value=" ログイン ">
								</FORM>
								</c:when>
								<c:otherwise><%--商品詳細以外から--%>
								<h2>ログイン</h2><br>
								<FORM action="login2.jsp" method="POST">
									<input type="hidden" name="jspCode" value="${formjsp}" />
									ユーザー名<BR>
									<INPUT TYPE="text" NAME="customerName" SIZE="30" MAXLENGTH="50"><BR><BR>
									パスワード<BR>
									<INPUT TYPE="password" NAME="password" SIZE="30" MAXLENGTH="10"><BR><BR>
									<INPUT TYPE="submit" value=" ログイン ">
								</FORM>
								</c:otherwise>
							</c:choose>
					</div>
					<div class="register">
					<c:choose>
						<c:when test="${!empty productCode}"><%--商品詳細から--%>
						<h2>新規登録</h2><br>
						<FORM action="register.jsp" method="POST">
							<input type="hidden" name="jspCode" value="${formjsp}" />
							<input type="hidden" name="hiddenCode" value="${productCode}" />
							ユーザー名<BR>
							<INPUT TYPE="text" NAME="customerName" SIZE="30" MAXLENGTH="50"><BR><BR>
							パスワード<BR>
							<INPUT TYPE="text" NAME="password" SIZE="30" MAXLENGTH="10"><BR><BR>
							住所<BR>
							<INPUT TYPE="text" NAME="address" SIZE="30" MAXLENGTH="50"><BR><BR>
							カード番号<BR>
							<INPUT TYPE="text" NAME="cardNumber" SIZE="30" MAXLENGTH="50"><BR><BR>
							セキュリティーコード<BR>
							<INPUT TYPE="text" NAME="cardCode" SIZE="30" MAXLENGTH="50"><BR><BR>
							<INPUT TYPE="submit" value="登録">
					  </FORM>
						</c:when>
						<c:otherwise><%--商品詳細以外から--%>
					  <h2>新規登録</h2><br>
						<FORM action="register.jsp" method="POST">
						<input type="hidden" name="jspCode" value="${formjsp}" />
						ユーザー名<BR>
						<INPUT TYPE="text" NAME="customerName" SIZE="30" MAXLENGTH="50"><BR><BR>
						パスワード<BR>
						<INPUT TYPE="text" NAME="password" SIZE="30" MAXLENGTH="10"><BR><BR>
						住所<BR>
						<INPUT TYPE="text" NAME="address" SIZE="30" MAXLENGTH="50"><BR><BR>
						カード番号<BR>
						<INPUT TYPE="text" NAME="cardNumber" SIZE="30" MAXLENGTH="50"><BR><BR>
						セキュリティーコード<BR>
						<INPUT TYPE="text" NAME="cardCode" SIZE="30" MAXLENGTH="50"><BR><BR>
						<INPUT TYPE="submit" value="登録">
						</FORM>
						</c:otherwise>
					</c:choose>
				</div>
			</center>
		</BODY>
	</HTML>
