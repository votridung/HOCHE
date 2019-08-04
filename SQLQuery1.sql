CREATE DATABASE QLBANHANG
GO 
USE QLBANHANG 
GO

CREATE TABLE KHACHHANG (
	MAKH	varchar	(5) PRIMARY KEY,
	TENKH	nvarchar (30) NOT NULL,
	DIACHI	nvarchar (50),
	DT	varchar	(11) CHECK ( DT LIKE '{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE NULL
						 ),
	EMAIL	varchar	(30)
) 

CREATE TABLE KH_VIP (
	MAKH	varchar	(15),
	TENKH	nvarchar (30) NOT NULL,
	DIACHI	nvarchar (50),
	DT	varchar	(11) CHECK ( DT LIKE '{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE	'{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}{0-9}'
						OR DT LIKE NULL
						 ),
	EMAIL	varchar	(30)
) 
CREATE TABLE VATTU(
	MAVT	varchar	(5) PRIMARY KEY,
	TENVT	Nvarchar (30) NOT NULL,
	DVT	Nvarchar (20),
	GIAMUA	Money CHECK (GIAMUA > 0) ,	
	SLTON	Int	CHECK(SLTON >= 0),

)
CREATE TABLE HOADON(
	MAHD	varchar	(10) PRIMARY KEY,
	NGAY	SmallDateTime CHECK (NGAY < GETDATE()),	
	MAKH	varchar	(5) FOREIGN KEY REFERENCES KHACHHANG(MAKH),
	TONGTG	Float
)
CREATE TABLE CTHD (
	MAHD	varchar	(10) FOREIGN KEY REFERENCES HOADON(MAHD),
	MAVT	varchar	(5) FOREIGN KEY REFERENCES VATTU(MAVT),
	SL	int,
	KHUYENMAI	Float,
	GIABAN	Float 

) 










--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW CAU1
AS
	select * from KHACHHANG
	where DIACHI = N'Tân Bình'
--SELECT * FROM CAU1

--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng, địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.
CREATE VIEW CAU2 
AS 
	select * from KHACHHANG
	where DT IS NULL
--SELECT * FROM CAU2 

--3.	Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ Email gồm mã khách hàng, tên khách hàng, địa chỉ.
CREATE VIEW CAU3 
AS  
	SELECT MAKH,TENKH,DIACHI 
	FROM KHACHHANG
	WHERE DT IS NULL AND EMAIL IS NULL
--SELECT * FROM CAU3

--4.	Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.

CREATE VIEW CAU4
AS 
	SELECT * FROM KHACHHANG
	WHERE DT IS NOT NULL AND EMAIL IS NOT NULL
	--SELECT * FROM CAU4

--5.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.

CREATE VIEW CAU5
AS
	SELECT * FROM VATTU
	WHERE DVT = N'Cái'

--6.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua trên 25000.
CREATE VIEW CAU6
AS
SELECT * FROM VATTU 
WHERE GIAMUA > 25000

--7.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, đơn vị tính và giá mua. 

CREATE VIEW CAU7
AS
SELECT * FROM VATTU 
WHERE TENVT LIKE N'Gạch%'
--8.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua nằm trong khoảng từ 20000 đến 40000.
CREATE VIEW CAU8
AS
SELECT * FROM VATTU
WHERE GIAMUA BETWEEN 20000 AND 40000
--9.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại.
CREATE VIEW CAU9
AS
SELECT A.MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON A , KHACHHANG B
WHERE B.MAKH = A.MAKH
--10.	Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của ngày 25/5/2010.
SET DATEFORMAT DMY

CREATE VIEW CAU10
AS
SELECT A.MAHD, TENKH,DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND A.NGAY = '25/5/2010'
--11.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của những hóa đơn trong tháng 6/2010.
CREATE VIEW CAU11
AS
SELECT A.MAHD, TENKH,DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(A.NGAY)=6 AND YEAR(A.NGAY)=2010
--12.	Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại) đã mua hàng trong tháng 6/2010.
CREATE VIEW CAU12
AS
SELECT TENKH,DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(A.NGAY)=6 AND YEAR(A.NGAY)=2010
--13.	Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm các thông tin tên khách hàng, địa chỉ, số điện thoại.
CREATE VIEW CAU13
AS
SELECT TENKH,DIACHI, DT, NGAY
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND A.NGAY NOT IN ( 
				SELECT NGAY
				FROM HOADON A, KHACHHANG B
				WHERE A.MAKH = B.MAKH AND MONTH(A.NGAY)=6 AND YEAR(A.NGAY)=2010)
--14.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng).

CREATE VIEW CAU14
AS
SELECT TENKH,DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(A.NGAY)=6 AND YEAR(A.NGAY)=2010

--15.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, 
-- trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.
CREATE VIEW CAU15
AS
SELECT C.MAHD, B.MAVT,B.TENVT, B.DVT, C.GIABAN, B.GIAMUA, C.SL , (GIAMUA * SL) AS 'TRỊ GIÁ MUA', (GIABAN * SL) AS 'TRỊ GIÁ BÁN'
FROM VATTU B, CTHD C
WHERE B.MAVT = C.MAVT AND GIABAN >= GIAMUA

--16.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng),
-- trị giá bán (giá bán * số lượng) và cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn hơn 100.\
CREATE VIEW CAU16
AS
SELECT C.MAHD, B.MAVT,B.TENVT, B.DVT, C.GIABAN, B.GIAMUA, C.SL , (GIAMUA * SL) AS 'TRỊ GIÁ MUA', (GIABAN * SL) AS 'TRỊ GIÁ BÁN' ,
	[KHUYENMAI] = IIF(SL>100,0.1,0)*SL*GIABAN
FROM  VATTU B, CTHD C
WHERE B.MAVT = C.MAVT 

--17.	Tìm ra những mặt hàng chưa bán được.
CREATE VIEW CAU17
AS
SELECT B.MAVT,B.TENVT, B.DVT, B.GIAMUA, B.SLTON
FROM  VATTU B, CTHD C
WHERE B.MAVT = C.MAVT AND C.MAVT NOT IN (SELECT MAVT FROM CTHD)

--18.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, 
-- giá bán, số lượng, trị giá mua, trị giá bán. 
CREATE VIEW CAU18
AS
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT, D.TENVT, D.DVT, D.GIAMUA, C.GIABAN, C.SL , (GIAMUA * SL) AS 'TRỊ GIÁ MUA',
 (GIABAN * SL) AS 'TRỊ GIÁ BÁN'
FROM  HOADON B, CTHD C, KHACHHANG A, VATTU D
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH AND C.MAVT = D.MAVT
--19.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, 
-- đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
CREATE VIEW CAU19
AS
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT, D.TENVT, D.DVT, D.GIAMUA, C.GIABAN, C.SL , (GIAMUA * SL) AS 'TRỊ GIÁ MUA',
 (GIABAN * SL) AS 'TRỊ GIÁ BÁN'
FROM  HOADON B, CTHD C, KHACHHANG A, VATTU D
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH AND C.MAVT = D.MAVT AND MONTH(B.NGAY)=5 AND YEAR(B.NGAY)=2010

--20.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, 
-- đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
CREATE VIEW CAU20
AS
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT, D.TENVT, D.DVT, D.GIAMUA, C.GIABAN, C.SL , (GIAMUA * SL) AS 'TRỊ GIÁ MUA',
 (GIABAN * SL) AS 'TRỊ GIÁ BÁN'
FROM  HOADON B, CTHD C, KHACHHANG A, VATTU D
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH AND C.MAVT = D.MAVT AND MONTH(B.NGAY) BETWEEN 1 AND 3 AND YEAR(B.NGAY)=2010 

--21.	Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
CREATE VIEW CAU21
AS
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY MAHD
--22.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
CREATE VIEW CAU22
AS
SELECT TOP 1 WITH TIES C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY SUM(C.GIABAN * SL) DESC
--23.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, 
-- tổng trị giá của hóa đơn.

CREATE VIEW CAU23
AS
SELECT TOP 1 WITH TIES C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH AND MONTH(B.NGAY)=5 AND YEAR(B.NGAY)=2010
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY SUM(C.GIABAN * SL) DESC

--24.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.

CREATE VIEW CAU24
AS
SELECT  A.TENKH, A.DIACHI, A.DT , [SỐ HÓA ĐƠN] = COUNT(B.MAKH) 
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH
GROUP BY  A.TENKH, A.DIACHI, A.DT
ORDER BY A.TENKH

--25.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.

CREATE VIEW CAU25
AS
SELECT A.MAKH, A.TENKH, A.DIACHI, A.DT , [THÁNG]= MONTH(B.NGAY), [SỐ HÓA ĐƠN] = COUNT(B.MAHD) 
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY A.MAKH,  A.TENKH, A.DIACHI, A.DT, MONTH(B.NGAY)
ORDER BY A.TENKH 

--26.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.

CREATE VIEW CAU26
AS
SELECT A.MAKH, A.TENKH, A.DIACHI, A.DT, [SỐ HÓA ĐƠN] = COUNT(B.MAHD) 
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY A.MAKH,  A.TENKH, A.DIACHI, A.DT
ORDER BY COUNT(B.MAKH) DESC

--27.	Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.
CREATE VIEW CAU27
AS
SELECT A.MAKH, A.TENKH, A.DIACHI, A.DT, [SỐ LƯỢNG] = SUM(C.SL) 
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY A.MAKH,  A.TENKH, A.DIACHI, A.DT
ORDER BY SUM(C.SL)  DESC
--28.	Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.

CREATE VIEW CAU28
AS
SELECT A.MAVT, A.TENVT, A.DVT, A.GIAMUA, [SỐ HÓA ĐƠN] = COUNT(A.MAVT) 
FROM VATTU A, HOADON B, CTHD C 
WHERE B.MAHD = C.MAHD AND A.MAVT = C.MAVT
GROUP BY  A.MAVT, A.TENVT, A.DVT, A.GIAMUA
ORDER BY COUNT(A.MAVT) DESC

--29.	Lấy ra các thông tin về các mặt hàng mà được bán nhiều nhất.

CREATE VIEW CAU29
AS
SELECT A.MAVT, A.TENVT, A.DVT, A.GIAMUA, [SỐ LƯỢNG BÁN] = SUM(C.SL) 
FROM VATTU A, HOADON B, CTHD C 
WHERE B.MAHD = C.MAHD AND A.MAVT = C.MAVT
GROUP BY  A.MAVT, A.TENVT, A.DVT, A.GIAMUA
ORDER BY SUM(C.SL) DESC
--30.	Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ, số lượng hóa đơn đã mua 
--  (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn để trống)
CREATE VIEW CAU30
AS
SELECT A.MAKH, A.TENKH, A.DIACHI, [SỐ LƯỢNG HÓA ĐƠN] = COUNT(MAHD)
FROM  HOADON B,  KHACHHANG A
WHERE  A.MAKH = B.MAKH 
GROUP BY A.MAKH,  A.TENKH, A.DIACHI, A.DT


--Câu 4: Tạo các procedure sau:
--1.	Lấy ra danh các khách hàng đã mua hàng trong ngày X, với X là tham số truyền vào.
SET DATEFORMAT DMY
GO 

CREATE PROC C1 @X SMALLDATETIME
AS 
SELECT A.MAKH, A.TENKH, A.DIACHI, A.DT 
FROM KHACHHANG A , HOADON B  
WHERE A.MAKH = B.MAKH AND B.NGAY = @X 

--2.	Lấy ra danh sách khách hàng có tổng trị giá các đơn hàng lớn hơn X (X là tham số).
GO

CREATE PROC C2 @X INT
AS 
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
HAVING  SUM(C.GIABAN * SL) > @X

--3.	Lấy ra danh sách X khách hàng có tổng trị giá các đơn hàng lớn nhất (X là tham số).
GO 

CREATE PROC C3 @X INT
AS 
SELECT TOP (@X) WITH TIES C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY SUM(C.GIABAN * SL) DESC

--4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất (X là tham số).
GO 

CREATE PROC C4 @X INT
AS 
SELECT TOP (@X) WITH TIES  A.MAVT, A.TENVT, A.DVT, A.GIAMUA, [SỐ LƯỢNG BÁN] = SUM(C.SL) 
FROM VATTU A, HOADON B, CTHD C 
WHERE B.MAHD = C.MAHD AND A.MAVT = C.MAVT
GROUP BY  A.MAVT, A.TENVT, A.DVT, A.GIAMUA
ORDER BY SUM(C.SL) DESC

--5.	Lấy ra danh sách X mặt hàng bán ra có lãi ít nhất (X là tham số).
GO

CREATE PROC C5 @X INT
AS 
SELECT TOP (@X) B.MAVT,B.TENVT, B.DVT, [LÃI]=SUM(C.GIABAN * SL)-SUM(GIAMUA * SL)
FROM  VATTU B, CTHD C
WHERE B.MAVT = C.MAVT 
GROUP BY  B.MAVT,B.TENVT, B.DVT
ORDER BY SUM(C.GIABAN * SL)-SUM(GIAMUA * SL)

--6.	Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).
GO

CREATE PROC C6 @X INT
AS 
SELECT TOP (@X) WITH TIES C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY SUM(C.GIABAN * SL) DESC

--7.	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL > 100, 10% nếu SL > 500.
GO

CREATE PROC C7
AS
UPDATE CTHD
SET [KHUYENMAI] = (CASE WHEN SL>500 THEN 0.1
						WHEN SL>100 THEN 0.05
						ELSE 0
						END)*SL*GIABAN;

EXEC C7
--8.	Tính lại số lượng tồn cho tất cả các mặt hàng (SLTON = SLTON – tổng SL bán được).
GO

CREATE PROC C8
AS
UPDATE VATTU
SET SLTON = SLTON - (SELECT SUM(C.SL) 
FROM  CTHD C 
WHERE VATTU.MAVT = C.MAVT)

EXEC C8
--9.	Tính trị giá cho mỗi hóa đơn.
GO

CREATE PROC C9
AS
SELECT C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT,  SUM(C.GIABAN * SL) AS ' TỔNG TRỊ GIÁ MUA'
FROM  HOADON B, CTHD C, KHACHHANG A
WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
GROUP BY C.MAHD, B.NGAY, A.TENKH, A.DIACHI, A.DT
ORDER BY MAHD
EXEC C9

--10.	Tạo ra table KH_VIP có cấu trúc giống với cấu trúc table KHACHHANG. Lưu các khách hàng có tổng trị giá của tất cả các đơn hàng >=10.000.000 vào table KH_VIP.
GO

CREATE PROC C10 
AS 
INSERT INTO KH_VIP 
SELECT A.MAKH,  A.TENKH, A.DIACHI, A.DT, A.EMAIL
			FROM  HOADON B, CTHD C, KHACHHANG A
			WHERE B.MAHD = C.MAHD AND A.MAKH = B.MAKH 
			GROUP BY A.MAKH,  A.TENKH, A.DIACHI, A.DT, A.EMAIL
			HAVING SUM(C.GIABAN * SL) >= '10000000'

EXEC C10