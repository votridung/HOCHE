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
GO 









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
SELECT TENKH,DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(A.NGAY)=6 AND YEAR(A.NGAY)=2010
--15.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.
--16.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) và cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn hơn 100.
--17.	Tìm ra những mặt hàng chưa bán được.
--18.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
--19.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
--20.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
--21.	Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
--22.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
--23.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
--24.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.
--25.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.
--26.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
--27.	Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.
--28.	Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.
--29.	Lấy ra các thông tin về các mặt hàng mà được bán nhiều nhất.
--30.	Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ, số lượng hóa đơn đã mua (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn để trống)
