<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<%--
	データベースへのコネクションを取得
--%>
<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />

<c:set var="formName" value="${param.hiddenName}" />

<c:set var="formProductCode" value="${param.productCode}" />
<c:set var="formMakerName" value="${param.makerName}" />
<c:set var="formIMAGE" value="${param.IMAGE}" />
<c:set var="formPrice" value="${param.Price}" />
<c:set var="formHistory" value="${param.History}" />
<c:set var="formNumber" value="${param.Number}" />

<sql:update>
	INSERT INTO CART VALUES(?,?,?,?,?,?,?);
	<sql:param value="${formName}" />
	<sql:param value="${formProductCode}" />
	<sql:param value="${formMakerName}" />
	<sql:param value="${formIMAGE}" />
	<sql:param value="${formPrice}" />
	<sql:param value="${formNumber}" />
	<sql:param value="${formHistory}" />
</sql:update>

<sql:query var="rs">
	SELECT *, PRICE*NUMBER as SUM FROM CART
	WHERE CUSTOMER_NAME=? AND HISTORY='yet' ORDER BY PRODUCT_CODE;
	<sql:param value="${formName}" />
</sql:query>

<sql:query var="mk">
	SELECT MAKER_CODE, MAKER_NAME
	FROM MAKER_INFO ORDER BY MAKER_CODE;
</sql:query>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
		<TITLE>衣料品販売</TITLE>

		<%--

		表示方法の設定

	--%>

	<STYLE type="text/css">
	body {background-color:#696969;}
	img {vertical-align: middle;}
	.main { width:80%; float:left; font-family:serif;}
	.side { width:20%; float:left; font-family:serif;}
	.row{position: relative; margin : 20px; font-family:serif;
		width:300px; height: 350px; float:left; border:1px solid #ff6a00;}

		.detail{padding-left: 40px; text-align:left;}
		.header img{width: 100%;}
		.image a:hover img{opacity: 0.4;}
		.buy{text-align: center;}
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
						<h2>カート内の商品</h2>
						<FORM action="cart2.jsp" method="POST">
							<input type="hidden" name="hiddenName" value="${formName}" />
							<INPUT TYPE="submit" value="カート一括削除">
							</FORM><BR>
							<FORM action="list2.jsp" method="POST">
								<input type="hidden" name="hiddenName" value="${formName}" />
								<INPUT TYPE="submit" value="買い物を続ける">
								</FORM><BR>
								<FORM action="buy.jsp" method="POST">
									<input type="hidden" name="hiddenName" value="${formName}" />
									<INPUT TYPE="submit" value="購入">
									</FORM>
									<c:forEach var="row" items="${rs.rows}">
										<div class="row">
											<div class="image">
												<a href="detail.jsp?productCode=${row.PRODUCT_CODE}&hiddenName=${formName}">
													<img src="image/${row.IMAGE}" height="200px" /></a>
												</div>
												<BR>
													<div class="detail">
														メーカー:${row.MAKER_NAME}<BR>
														販売価格:${row.PRICE}円<BR>
														数量：${row.Number}着<BR>
														<FORM action="cart2.jsp" method="POST">
															<input type="hidden" name="hiddenName" value="${formName}" />
															<input type="hidden" name="productCode" value="${row.PRODUCT_CODE}" />
															<INPUT TYPE="submit" value="カートから削除">
															</FORM>
														</div>
													</div>
												</c:forEach>
											</center>
										</div>
									</BODY>
								</HTML>
