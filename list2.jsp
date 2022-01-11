<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />
	<%--データベースからデータを取得して、変数rsに結果を入れる。
	[PRODUCT_INFO]テーブルから [PRODUCT_CODE], [PRODUCT_NAME],
	[CATEGORY_NAME], [MAKER_NAME], [DETAIL], [MATERIAL], [SIZE], [IMAGE],
	[PRICE] を [PRODUCT_CODE]の昇順で検索するSQL文。--%>

	<sql:query var="rs">
		SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
		FROM PRODUCT_INFO ORDER BY PRODUCT_CODE;
	</sql:query>

	<sql:query var="mk">
		SELECT MAKER_CODE, MAKER_NAME
		FROM MAKER_INFO ORDER BY MAKER_CODE;
	</sql:query>
	<c:set var="formName" value="${param.hiddenName}" />

	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
			<TITLE>衣料品販売</TITLE>
			<STYLE type="text/css">
			body {background-color:#696969;}
			img {vertical-align: middle;}
			.main { width:80%; float:left;}
			.side { width:20%; float:left; font-family:serif;}
			.row{position: relative; margin : 20px; font-family:serif;
				width:300px; height: 350px; float:left; border:1px solid #ff6a00;}
				.row a{display:block; position: absolute;	top:0; left: 0;	width: 100%; height: 100%;}
				.row:hover{color: #ffffff; background-color: #a9a9a9;}
				.detail{padding-left: 40px; text-align:left;}
				.header img{width: 100%;}
				ul {
					margin: 10 ;
					padding: 0;
					list-style-type: none;
					background-color: #505050;
				}
				li a {
					display: block;
					padding: 8px 16px;
					text-decoration: none;
					color: #000000;
					border-bottom: solid;
					border-bottom-color: #000000;
				}
				li a.category{
					color: #ffffff;
					background-color: #544a47;
				}
				li a:hover:not(.category) {
					color: #ffffff;
					background-color: #a9a9a9;
				}
				</style>
			</head>
			<BODY>
				<p class="header">
					<a href="list2.jsp?hiddenName=${formName}"><img src="image/top.jpg" alt="トップ画像"/></a>
				</p>
				<div class="side">
					<c:choose>
						<c:when test="${!empty formName}">
							ユーザー名：${formName}
							<FORM action="list2.jsp" method="POST">
								<INPUT type="submit" name="logout" value="ログアウト">
								</FORM>
								<FORM action="cart.jsp" method="POST">
									<input type="hidden" name="hiddenName" value="${formName}" />
									<INPUT type="submit" name="logout" value="カートへ">
									</FORM>
								</c:when>
								<c:otherwise>
									未ログイン
									<FORM action="login.jsp" method="POST">
										<input type="hidden" name="jspCode" value="list2" />
										<INPUT type="submit" name="login" value="ログイン">
										</FORM>
									</c:otherwise>
								</c:choose>

								<ul>
									<li><a class="category">Brand</a></li>
									<c:forEach var="row" items="${mk.rows}">
										<li><a href="list3.jsp?makerName=${row.MAKER_NAME}&hiddenName=${formName}"> ${row.MAKER_NAME}</a></li>
									</c:forEach>
								</ul>
							</div>

							<div class="main">
								<center>
									<FORM action="detail.jsp" method="POST">
										<c:forEach var="row" items="${rs.rows}">
											<div class="row">
												<a href="detail.jsp?productCode=${row.PRODUCT_CODE}&hiddenName=${formName}"></a>
												<img src="image/${row.IMAGE}" height="200px" /><BR>
												<BR>
													<div class="detail">
														メーカー:${row.MAKER_NAME}<BR>
														製品名:${row.PRODUCT_NAME}<BR>
														販売価格:${row.PRICE}円<BR>
													</div>
												</div>
											</c:forEach>
										</FORM>
									</center>
								</div>
							</BODY>
						</HTML>
