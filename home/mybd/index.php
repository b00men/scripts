<?php

$link = mysql_connect('127.0.0.1', 'root', 'Adnimus')
    or die('Не удалось соединиться: ' . mysql_error());
mysql_select_db('postdb') or die('Не удалось выбрать базу данных');

$query_col="SHOW COLUMNS FROM table"; 
$query = 'SELECT * FROM magazin, post, reading WHERE post.addr=reading.addr AND magazin.num_mag=reading.num_mag ';

$post[0] = ($_POST['mag_n']) ? ("magazin.num_mag = " . $_POST['mag_n']) : '';
$post[1] = ($_POST['mag_name']) ? ("name LIKE '%{$_POST['mag_name']}%'") : '';
$post[2] = ($_POST['mag_date']) ? ("date LIKE '%{$_POST['mag_date']}%'") : '';
$post[3] = ($_POST['post_n']) ? ("num = " . $_POST['post_n']) : '';
$post[4] = ($_POST['post_addr']) ? ("post.addr LIKE '%{$_POST['post_addr']}%'") : '';
$post[5] = ($_POST['post_p_addr']) ? ("addr_post LIKE '%{$_POST['post_p_addr']}%'") : '';

for ($i=0;$i<6;$i++) if ($post[$i]) $query=$query . "AND " . $post[$i];

$result_col = mysql_query($query) or die('Запрос не удался: ' . mysql_error());
$result = mysql_query($query) or die('Запрос не удался: ' . mysql_error());
?>

<html>
<body>
<h2>База подписчиков</h2>
<form action="index.php" method="post">

	<h3>Поиск по:</h3>
	<p>Адрес подписчика: <input type="text" name="post_addr" /></p>
	<p>Название журнала: <input type="text" name="mag_name" /></p>
	<p>Номер журнала: <input type="text" name="mag_n" /></p>
	<p>Дата начала издания: <input type="text" name="mag_date" /></p>
	<p>Номер почтового отделения: <input type="text" name="post_n" /></p>
	<p>Адрес почтового отделения: <input type="text" name="post_p_addr" /></p>

	<p><input type="submit"  value="Поиск" /></p>
</form>

<table  border=1>
	<tr>
<?php 
$d=mysql_fetch_array($result_col,MYSQL_ASSOC);  
foreach($d as $col_name=>$v){ echo "\t\t<td>$col_name</td>\n"; }
?>
	</tr>
<?php
while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) { echo "\t\t<td>$col_value</td>\n"; }
    echo "\t</tr>\n";
}
?>
</table>
</body>
</html>

<?php 
mysql_free_result($result);
mysql_close($link);
?>