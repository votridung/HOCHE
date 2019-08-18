CREATE DATABASE BAI3
GO 
USE BAI3 
GO

CREATE TABLE Loai(
	MaLoai	char(5) PRIMARY KEY,
	TenLoai	nvarchar (30) NOT NULL,
) 

CREATE TABLE SanPham(
	MaSP	char(5) PRIMARY KEY,
	TenSP	nvarchar (30) NOT NULL,
	MaLoai	char(5) FOREIGN KEY REFERENCES Loai(MaLoai)
) 
CREATE TABLE NhanVien(
	MaNV	char(5) PRIMARY KEY,
	HoTen	Nvarchar (30) NOT NULL,
	NgaySinh Nvarchar (20) CHECK ( year(GETDATE())- year(NgaySinh) >=18 and year(GETDATE())- year(NgaySinh) <= 55 ),
	Phai	INT CHECK(Phai LIKE 1 or Phai LIKE 2 or Phai LIKE 0),
)
CREATE TABLE PhieuXuat (
	MaPX	INT PRIMARY KEY IDENTITY(1,1),
	NgayLap	SmallDateTime CHECK (NgayLap < GETDATE()),	
	MaNV	char(5) FOREIGN KEY REFERENCES NhanVien(MaNV)
)
CREATE TABLE CTPX  (
	MaPX	INT FOREIGN KEY REFERENCES PhieuXuat(MaPX),
	MaSP	char(5) FOREIGN KEY REFERENCES SanPham(MaSP),
	SL	int,
) 

--1.	Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. 
--Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.
SET DATEFORMAT DMY
SELECT A.MaSP, A.TenSP, SUM(SL) AS 'TONG SL'
FROM SanPham A , CTPX B, PhieuXuat C
WHERE A.MaSP=B.MaSP AND B.MaPX = C.MaPX AND YEAR(NgayLap)=2010
GROUP BY A.MaSP, A.TenSP
ORDER BY TenSP
--2.	Cho biết mã sản phẩm, tên sản phẩm, tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.
SELECT A.MaSP, A.TenSP, D.TenLoai
FROM SanPham A , CTPX B, PhieuXuat C, Loai D
WHERE A.MaSP=B.MaSP AND B.MaPX = C.MaPX AND A.MaLoai=D.MaLoai AND MONTH(NgayLap)>=1 AND MONTH(NgayLap)<7 AND YEAR(NgayLap)=2010
GROUP BY A.MaSP, A.TenSP,D.TenLoai
	
--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, 
--số lượng các sản phẩm.
SELECT A.MaLoai, C.TenLoai, A.TenSP, SUM(B.SL)
FROM SanPham A ,  Loai C, CTPX B 
WHERE A.MaSP=B.MaSP AND A.MaLoai=C.MaLoai 
GROUP BY A.MaLoai, TenLoai , TenSP
ORDER BY MaLoai
--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010.
SELECT A.MaPX,COUNT(B.MaPX)
FROM PhieuXuat A , CTPX B 
WHERE A.MaPX=B.MaPX AND MONTH(NgayLap)=6 AND YEAR(NgayLap)=2010
GROUP BY A.MaPX

--5.	Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.
SELECT A.* 
FROM PhieuXuat A , NhanVien B
WHERE A.MaNV=B.MaNV AND B.MaNV LIKE 'NV01'

--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
SELECT A.* 
FROM NhanVien A
WHERE Phai = 1 AND YEAR(GETDATE())-YEAR(A.NgaySinh) > 25 AND YEAR(GETDATE())- YEAR(A.NgaySinh)< 30
--7.	Thống kê số lượng phiếu xuất theo từng nhân viên.
SELECT B.HoTen, B.MaNV, COUNT(A.MaPX) AS 'SO LUONG PHIEU XUAT'
FROM PhieuXuat A , NhanVien B
WHERE A.MaNV=B.MaNV
GROUP BY HoTen,B.MaNV
--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
SELECT A.TenSP, SUM(B.SL) AS 'SL SP DA XUAT'
FROM SanPham A ,  CTPX B 
WHERE A.MaSP=B.MaSP 
GROUP BY  TenSP
ORDER BY TenSP
--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
SELECT TOP 1 B.HoTen, B.MaNV, COUNT(A.MaPX) AS 'SO LUONG PHIEU XUAT'
FROM PhieuXuat A , NhanVien B
WHERE A.MaNV=B.MaNV
GROUP BY HoTen,B.MaNV
ORDER BY  COUNT(A.MaPX) DESC
--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010
SELECT TOP 1 B.TenSP, SUM(SL) AS 'SO LUONG PHIEU XUAT'
FROM PhieuXuat A , SanPham B, CTPX C
WHERE A.MaPX=C.MaPX AND B.MaSP=C.MaSP
GROUP BY  B.TenSP
ORDER BY  SUM(SL) DESC


--1.	Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất kho của tên sản phẩm này trong năm này. 
--(Chú ý: Nếu tên sản phẩm này không tồn tại thì phải trả về 0)
GO

CREATE FUNCTION C21(@TENSP NVARCHAR(30), @NAM VARCHAR(5))
RETURNS BIGINT 
AS 
BEGIN	
	DECLARE @SLXUAT BIGINT 
	SELECT @SLXUAT = ISNULL(SUM(SL),0)
	FROM SanPham A , PhieuXuat B, CTPX C 
	WHERE A.MaSP=C.MaSP AND C.MaPX=B.MaPX AND YEAR(NgayLap)=@NAM AND TenSP LIKE @TENSP
	GROUP BY  TenSP
	RETURN @SLXUAT
END

DECLARE @TENSP NVARCHAR(30), @NAM VARCHAR(5)
SET @TENSP = N'Gạch'
SET @NAM = '2010'
PRINT 'TONG SL BAN CUA: ' +CAST(@TENSP AS VARCHAR) + ' LA : ' +CAST(dbo.C21(@TENSP,@NAM)AS VARCHAR)
--2.	Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. 
--Nếu nhân viên này không tồn tại thì trả về 0.
GO

CREATE FUNCTION C22(@MANV CHAR(5))
RETURNS BIGINT 
AS 
BEGIN	
	DECLARE @SLXUAT BIGINT 
	SELECT @SLXUAT = COUNT(A.MaPX)
	FROM PhieuXuat A , NhanVien B
	WHERE A.MaNV=B.MaNV and a.MaNV LIKE @MANV
	RETURN @SLXUAT
END

DECLARE @MANV CHAR(5)
SET @MANV = 'NV01'
PRINT 'TONG SL BAN CUA: ' +CAST(@MANV AS VARCHAR) + ' LA : ' +CAST(dbo.C22(@MANV)AS VARCHAR)

--3.	Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào.
 
CREATE FUNCTION C23(@NAM INT)
RETURNS @TONG TABLE
(
	MASP CHAR(5),
	TENSP NVARCHAR(30)
)
AS 
BEGIN	
	INSERT INTO @TONG
	SELECT A.MaSP, A.TenSP 
	FROM SanPham A , CTPX B, PhieuXuat C
	WHERE A.MaSP=B.MaSP AND B.MaPX = C.MaPX AND YEAR(NgayLap)= @NAM
	GROUP BY A.MaSP, A.TenSP
	ORDER BY TenSP
	RETURN 
END

DECLARE @NAM INT
SET @NAM =2010
PRINT 'TONG SL BAN CUA: ' +CAST(@NAM AS VARCHAR) + ' LA : ' +CAST(dbo.C23(@NAM)AS VARCHAR)


--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó.
 --Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.

--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.

--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.

--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
