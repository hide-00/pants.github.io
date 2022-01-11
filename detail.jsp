<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import="java.sql.*"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />
	<fmt:requestEncoding value="utf-8" />

	<c:set var="formProductCode" value="${param.productCode}" />
	<c:set var="formName" value="${param.hiddenName}" />

	<%--商品の在庫を検索する
	[PRODUCT_STOCK]テーブルから[PRODUCT_CODE], [MAKER_ID], [PC_NAME],
	[PC_TYPE], [SAL_VALUE], [SPEC], [STOCK_NUM]を検索するSQL文--%>
	<sql:query var="rs">
		SELECT STOCK_NUM
		FROM PRODUCT_STOCK WHERE PRODUCT_CODE = ?;
		<sql:param value="${formProductCode}" />
	</sql:query>

	<%-- 在庫数を変数[stockNum]に格納する --%>
	<c:choose>
		<c:when test="${rs.rowCount == 0}">
			<c:set var="stockNum" value="0" />
		</c:when>
		<c:otherwise>
			<c:set var="row" value="${rs.rows[0]}" />
			<c:set var="stockNum" value="${row.STOCK_NUM}" />
		</c:otherwise>
	</c:choose>

	<sql:query var="rs">
		SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
		FROM PRODUCT_INFO WHERE PRODUCT_CODE=? ORDER BY PRODUCT_CODE;
		<sql:param value="${formProductCode}" />
	</sql:query>
	<%-- 一行目を変数rowに代入 --%>
	<c:set var="row" value="${rs.rows[0]}" />

	<sql:query var="mk">
		SELECT MAKER_CODE, MAKER_NAME
		FROM MAKER_INFO ORDER BY MAKER_CODE;
	</sql:query>

	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
				<TITLE>詳細情報</TITLE>

				<STYLE type="text/css">
				body {background-color:#696969;}
				img {vertical-align: middle;}
				.main { width:80%; float:left; font-family:serif;}
				.side { width:20%; float:left; font-family:serif;}
				.header img{width: 100%;}
				.mainPic img{position: relative; margin : 20px; font-family:serif;
					height: 400px; float:left; border:1px solid #ff6a00;}
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
				</STYLE>
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
										<input type="hidden" name="productCode" value="${formProductCode}" />
										<INPUT type="submit" name="login" value="ログイン">
										</FORM>
									</c:otherwise>
								</c:choose>

								<ul>
									<li><a class="category">Brand</a></li>
									<c:forEach var="row2" items="${mk.rows}">
										<li><a href="list3.jsp?makerName=${row2.MAKER_NAME}&hiddenName=${formName}"> ${row2.MAKER_NAME}</a></li>
									</c:forEach>
								</ul>
							</div>

							<div class="main">
								<p class="mainPic">
									<img src="image/${row.IMAGE}" alt="メイン画像"/>
								</p>
								メーカー：${row.MAKER_NAME}<BR>
								<p>
									製品名：${row.PRODUCT_NAME}<BR><BR>
									素材：${row.MATERIAL}<BR><BR>
									説明：${row.DETAIL}<BR><BR><BR>
									販売価格：${row.PRICE}円<BR><BR>

									<FORM action="review.jsp" method="POST">
										<a href="review.jsp?productCode=${row.PRODUCT_CODE}&hiddenName=${formName}">口コミ</a><br>
									</form>
									<%--在庫数を確認して結果を表示する
									在庫数が1より少ないかどうかで在庫の確認を行っている--%>
									<c:choose>
										<c:when test="${stockNum < 1}">
											<%-- 商品の在庫が存在しない場合は、品切れの情報を出力する --%>
											申し訳ございません。${row.PRODUCT_NAME} は品切れです。<BR>
										</c:when>
										<c:when test="${stockNum >= 1 and !empty formName}">
											<%--ログイン済みの場合--%>
											<FORM action="cart.jsp" method="POST">
												<input type="hidden" name="productCode" value="${row.PRODUCT_CODE}" />
												<input type="hidden" name="makerName" value="${row.MAKER_NAME}" />
												<input type="hidden" name="IMAGE" value="${row.IMAGE}" />
												<input type="hidden" name="Price" value="${row.PRICE}" />
												<input type="hidden" name="History" value="yet" />
												<input type="hidden" name="hiddenName" value="${formName}" />
												<select name="Number">
													<option value="1">1着</option>
													<option value="2">2着</option>
													<option value="3">3着</option>
													<option value="4">4着</option>
													<option value="5">5着</option>
												</select>
												<INPUT type="submit" name="buttonBuy" value="カートに入れる">
												</FORM>
											</c:when>
											<c:otherwise><%--未ログイン--%>
											購入するにはログインが必要です<BR>
											<FORM action="login.jsp" method="POST">
												<input type="hidden" name="productCode" value="${formProductCode}" />
												<INPUT type="submit" name="login" value="ログイン">
												</FORM>
											</c:otherwise>
										</c:choose>
									</div>
								</BODY>
							</HTML>
