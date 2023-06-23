use master
go

drop database ShopOnlineMultiShop_Demo
go
-- Tạo database ShopOnline_Demo
create database ShopOnlineMultiShop_Demo
go
use ShopOnlineMultiShop_Demo
go
-- 1: Tạo Table [Accounts] chứa tài khoản thành viên được phép sử dụng các trang quản trị ----
create table TaiKhoan
(
	taiKhoan varchar(20) primary key not null,
	matKhau varchar(20) not null,
	hoDem nvarchar(50) null,
	tenTV nvarchar(30) not null,
	ngaysinh datetime ,
	gioiTinh bit default 1,
	soDT nvarchar(20),
	email nvarchar(50),
	diaChi nvarchar(250),
	trangThai bit default 0,
	ghiChu ntext
)
go

-- 2: Tạo Table [Customers] chứa Thông tin khách hàng  ---------------------------------------

create table KhachHang
(
	maKH varchar(10) primary key not null,
	tenKH nvarchar(50) not null,
	soDT varchar(20) ,
	email varchar(50),
	diaChi nvarchar(250),
	ngaySinh datetime ,
	gioiTinh bit default 1,
	ghiChu ntext
)
go

-- 3: Tạo Table [Articles] chứa thông tin về các bài viết phục vụ cho quảng bá sản phẩm, ------
--    xu hướng mua sắm hiện nay của người tiêu dùng , ...             ------------------------- 
create table BaiViet
(
	maBV varchar(10) primary key not null,
	tenBV nvarchar(250) not null,
	hinhDD varchar(max),
	ndTomTat nvarchar(2000),
	ngayDang datetime ,
	loaiTin nvarchar(30),
	noiDung nvarchar(4000),
	taiKhoan varchar(20) not null ,
	daDuyet bit default 0,
	foreign key (taiKhoan) references taiKhoan(taiKhoan) on update cascade 
)
go
-- 4: Tạo Table [LoaiSP] chứa thông tin loại sản phẩm, ngành hàng -----------------------------
create table LoaiSP
(
	maLoai int primary key not null identity,
	tenLoai nvarchar(88) not null,
	ghiChu ntext default ''
)
go


-- Tạo database ShopOnline_Demo
drop table Comment
go
create table Comment
(
	maCmt varchar(10)  primary key not null,
	maSP varchar(10) not null foreign key references SanPham(maSP),
	tenKH nvarchar(50) not null,
	noidung nvarchar(30) not null
)
go

drop table Comment
go
create table CommentArticle
(
	tenKH nvarchar(50) primary key not null,
	maBV varchar(10) not null foreign key references BaiViet(maBV),
	noidung nvarchar(30) not null
)
go

-- Tao them table Giá Bán

-- 5: Tạo Table [Products] chứa thông tin của sản phẩm mà shop kinh doanh online --------------
create table SanPham
(
	maSP varchar(10) primary key not null,
	tenSP nvarchar(500) not NULL,
	hinhDD varchar(max) DEFAULT '',
	ndTomTat nvarchar(2000) DEFAULT '',
	ngayDang DATETIME DEFAULT CURRENT_TIMESTAMP,
	maLoai int not null references LoaiSP(maLoai),
	noiDung nvarchar(4000) DEFAULT '',
	taiKhoan varchar(20) not null foreign key references taiKhoan(taiKhoan) on update cascade,
	dvt nvarchar(32) default N'Cái',
	daDuyet bit default 0,
	giaBan INTEGER DEFAULT 0,
	giamGia INTEGER DEFAULT 0 CHECK (giamGia>=0 AND giamGia<=100),
	nhaSanXuat nvarchar(168) default ''
)
go

-- 6: Tạo Table [Orders] chứa danh sách đơn hàng mà khách đã đặt mua thông qua web ------------
create table DonHang
(
	soDH varchar(10) primary key not null ,
	maKH varchar(10) not null foreign key references khachHang(maKH),
	taiKhoan varchar(20) not null foreign key references taiKhoan(taiKhoan) on update cascade ,
	ngayDat datetime,
	daKichHoat bit default 1,
	ngayGH datetime,
	diaChiGH nvarchar(250),
	ghiChu ntext
)
go	

-- 7: Tạo Table [OrderDetails] chứa thông tin chi tiết của các đơn hàng ---
--    mà khách đã đặt mua với các mặt hàng cùng số lượng đã chọn ---------- 
create table CtDonHang	
(
	soDH varchar(10) not null foreign key references donHang(soDH),
	maSP varchar(10) not null foreign key references sanPham(maSP),
	soLuong int,
	giaBan bigint,
	giamGia BIGINT,
	PRIMARY KEY (soDH, maSP)
)
go


/*========================== Nhập dữ liệu mẫu ==============================*/

--Nhập thông tin tài khoản, tối thiểu 5 thành viên sẽ dùng để làm việc với các trang: Administrative pages
insert into taiKhoan
values('admin','dlmfvmamn123',N'Trần Minh ','Nhật',21/09/1996,1,0935694223,'tmn@gmail.com','472 CMT8, P.11,Q3, TP.HCM',1,'')
insert into taiKhoan
values('MinhDuc','dlmfvmamn123',N'Trần Minh','Đức',17/08/2003,1,0912699708,'tmd@gmail.com','76 Xô Viết , Nghệ Tĩnh',1,'')
insert into taiKhoan
values('YenNhi','dlmfvmamn123',N'Trần Xuân Yến','Nhi',17/04/2003,0,093455334,'txyn@gmail.com','Tân Đông Hiệp, Dĩ An , Bình Dương',1,'')
insert into taiKhoan
values('Nga','dlmfvmamn123',N'Phan Thị','Nga',30/12/1997,0,0337668975,'ptn@gmail.com','Số nhà 69 , An Bình , Dĩ An , Bình Dương',1,'')
insert into taiKhoan
values('ThiAnh','dlmfvmamn123',N'Lê Thị','Ánh',31/10/2003,0,0965599365,'lta@gmail.com','Hải An ,Hải Lăng , Quảng Trị',1,'')
insert into taiKhoan
values('ThoHoa','dlmfvmamn123',N'Nguyễn Thọ',N'Hòa',10/11/2003,1,097488393,'nth@gmail.com','Bình Đường 4 , An Bình , Dĩ An , Bình Dương',1,'')
GO

--Nhap cac loại sản phẩm
insert into LoaiSP(tenLoai) values(N'Giày')
insert into LoaiSP(tenLoai) values(N'Quần - Áo thời trang')
insert into LoaiSP(tenLoai) values(N'Túi xách')
insert into LoaiSP(tenLoai) values(N'Nón')
insert into LoaiSP(tenLoai) values(N'Son môi')
insert into LoaiSP(tenLoai) values(N'Dây chuyền')
insert into LoaiSP(tenLoai) values(N'Nước hoa')
go

insert into Comment(maSP,tenKH,noidung)
	values('1C',N'Tran Minh Duc',N'Cung kha la chat luong');
go
-- YC3: Nhập thông tin bài viết, Tối thiểu 10 bài viết thuộc loại: giới thiệu sản phẩm, khuyến mãi, quảng cáo, ... 
--      liên quan đến sản phẩm mà bạn dự định kinh doanh trong đồ án sẽ thực hiện


-- Giày(MALoaiSP 1) với MASP(1 + tên tắt của sản phẩm )
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1C', N'Giày Converse Chuck Taylor', '/Content/img/Converse.jpg',
			          N'Giày Sneaker Unisex Converse Chuck Taylor All Star Classic Low - Black/White
					  với thiết kế kiểu dáng cùng gam màu thời trang, mang đến cho bạn sự
					  trẻ trung, năng động nhưng cũng không kém phần sành điệu khi phối cùng các trang phục.', 
					 'admin',1295000,0,1,N'Converse',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Avi', N'Giày thể thao nam phong cách trẻ trung, lịch lãm Avi405', '/Content/img/giayavi.jpg',
			          N'Đế giày cao su non cao cấp đi êm chân, chống trơn trượt. Lót giày thông hơi, thoáng khí đi cực êm chân', 
					 'admin',163000,0,1,N'OEM',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Sneaker', N'Giày Sneaker nam phong cách thể thao', '/Content/img/sneaker.jpg',
			          N'Chất liệu VẢI êm chân, thoáng khí Đế cao su nguyên chất được sản xuất theo công nghệ Ý dẻo dai, giảm thiểu mòn đế
					  Keo dán chắc chắn, khâu đế cẩn thận. Đường may tỉ mỉ, cẩn thận, tinh tế', 'ThoHoa',165000,0,1,N'OEM',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1GT', N'GIẦY TÂY NAM THANH NIÊN GIÀY NAM DA BÒ ĐẾ CAO CẤP', '/Content/img/giaytay.jpg',
			          N'GIẦY TÂY NAM THANH NIÊN GIÀY NAM DA BÒ ĐẾ CAO CẤP - HÀNG ĐẸP FULL HỘP – FORM CHUẨN QUỐC 
					  TẾ-GIẦY TÂY NAM LÀM QUÀ TẶNG CHO BẠN TRAI ĐI SIÊU ÊM MS-1', 'admin',690000 ,10,1,N'OEM',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Chealsea', N'Giày Chelsea Boots Nam ', '/Content/img/chelsea.jpg',
			          N'Giày Chelsea Boots Nam Da Lộn Màu Vàng Bò TEFOSS HN601 Cao Cổ Da Thật Cao Cấp Size 38-43', 'admin',524000 ,10,1,N'TEFOSS',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Balance', N'Giày sneaker nam New Balance Mens', '/Content/img/balance.jpg',
			          N'GIẦY TÂY NAM THANH NIÊN GIÀY NAM DA BÒ ĐẾ CAO CẤP - HÀNG ĐẸP FULL HỘP – FORM CHUẨN QUỐC 
					  TẾ-GIẦY TÂY NAM LÀM QUÀ TẶNG CHO BẠN TRAI ĐI SIÊU ÊM MS-1', 'admin',690000 ,10,1,N'OEM',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1GT', N'Giày Nam da bò đế cao cấp', '/Content/img/giaytay.jpg',
			          N' Khi chạy bộ trở nên phổ biến rộng rãi vào những năm 1970, tiêu chuẩn dành cho giày chạy bộ đã nâng cao hơn,
					  chú trọng đến hiệu suất khi vận động.', 'admin',1197000 ,0,1,N'OEM',
					  N'Đôi');
go	
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1SND', N'Giày Thể Thao Nam Màu Đen, Sneaker Nam Màu Đen, Đế Êm, Nhẹ Thoáng Khí S355', '/Content/img/giaysneakerden.jpg',
			          N'Phần lót giày làm bằng đệm cấu trúc tổ ong, cho sự đàn hồi cao, mang rất êm chân, riêng phần lót này không bán ngoài thị trường ,
					  được gia công riêng cho dòng giày và không bị hư. Không bí chân, Giảm mồ hôi hiệu quả.', 'admin',269000 ,10,1,N'OEM',
					  N'Đôi');
go	


insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1KS', N'Giày K-Swiss HS329 Trek Mens Casual 06758-908-M', '/Content/img/giaykswiss.jpg',
			          N'Được biết đến là một trong những dòng giày cao cấp của Mỹ, K-Swiss sở hữu một thiết kế bền bỉ,
					  dẻo dai của thể thao nhưng không kém phần thời trang và cá tính.', 'admin',2000000 ,20,1,N'k-swiss',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Van', N'Giày Vans Old Skool "Los Vans" VN0A4U3BWN1', '/Content/img/giayvan.jpg',
			          N'Thiết kế ấn tượng với các chi tiết màu sắc nhẹ nhàng kết hợp họa tiết hình ảnh đặc biệt trên tường làm cho đôi 
					  giày nổi bật và lý tưởng để mang tại các sự kiện khác nhau.', 'admin',2100000 ,10,1,N'Vans',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1MD', N'Giày Thể Thao Nam MENDO ', '/Content/img/giaymendo.jpg',
			          N'Giày thể thao nam G5513 được nâng tầm với ngôn ngữ thiết kế mới - táo bạo hơn. 
					  Mẫu giày dễ dàng phối hợp với nhiều phong cách quần áo nhưng cũng không kém phần nổi bật. ', 'admin',275000 ,0,1,N'OEM',
					  N'Đôi');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Star', N'Giày Converse Chuck Taylor All Star Classic Low Top - 126196C', '/Content/img/giayconverseallstar.jpg',
			          N'Giày Sneaker Unisex Converse Chuck Taylor All Star Classic Low - Navy được thiết kế từ chất liệu vải canvas nhẹ, 
					  tạo cảm giác thoải mái cho người sử dụng. Thiết kế đế chống trơn trượt hiệu quả. ', 'admin',1295000 ,10,1,N'Converse',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Suc', N'Giày thể thao nữ/ giày sục nữ rách', '/Content/img/giaysuc.jpg',
			          N'Vải kaki mịn dày dặn, sợi vải dệt bóng hạn chế tối đa bám bui và sùi vải ', 'admin',169000  ,5,1,N'OEM',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Tron', N'Giày Thể Thao Nữ Dáng Trơn Kiểu Đế Bằng MEELY - LK90', '/Content/img/giaytron.jpg',
			          N'Kiểu dáng: Giày Thể Thao Nữ / Giày Sneaker Nữ.Chất liệu: Vật liệu tổng hợp ', 'admin',219000 ,0,1,N' MEELY',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1Thethaonu', N'Giày thể thao nữ đế êm nhẹ, thoáng khí đế cao su đúc', '/Content/img/giaythethaonu.jpg',
			          N'Giày là một vật dụng đi vào bàn chân con người để bảo vệ và làm êm chân trong khi thực hiện các hoạt động khác nhau.
					  Giày cũng được sử dụng như một món đồ trang trí', 'admin',320000 ,10,1,N' Bee Gee',
					  N'Đôi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('1TT', N'Giày Thể Thao Nữ Nâng Đế Dáng Trơn Trắng Tuyết MEELY', '/Content/img/giaytrang.jpg',
			          N'Kiểu dáng: Giày thể thao / sneaker nữ / Giày nâng đế / Độn Đế .Chất liệu: Vật liệu tổng hợp', 'admin',350000 ,20,1,N' MEELY',
					  N'Đôi');
go



--Quần - Áo Thời Trang(MALoaiSP 2) với MASP(2 + tên tắt của sản phẩm )
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2BK', N'Áo khoác Bucket Em bé', '/Content/img/aokhoacbucket.jpg',
			          N'ÁO KHOÁC GIÓ BÉ TRAI HÀN QUỐC MỚI NHẤT 2019 - ÁO KHOÁC TRẺ EM THỜI TRANG HÀN QUỐC', 'admin',350000,0,2,N'Bucket',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2J', N'Áo khoác Jeans ', '/Content/img/aokhoacjeanNam.jpg',
			          N'Áo Khoác Jeans Nam Nữ Thiết Kế Đẹp Mới Nhất 2020 QN48', 'admin',200000,0,2,N'Denim',
					  N'Chiếc');
go
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2AP', N'Áo Phông Nam Nữ ', '/Content/img/aophongnamnu.jpg',
			          N'Áo Thun Cổ Tròn Đơn Giản M28Chất liệu: Cotton 4 chiềuThành phần: 92% cotton 8% spandex', 'admin',150000,0,2,N'OEM',
					  N'Chiếc');
go
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2ĐN', N'Đồ ngủ em bé', '/Content/img/dongu.jpg',
			          N'Bộ Pijama Lụa Trơn Cho Bé Trai, Gái Dài Tay, Bộ Đồ Ngủ Cho Bé Chất Lụa Satin Cao Cấp Cực Xinh Cho Bé Yêu - SUMO KIDS', 'admin',200000,0,2,N'BB',
					  N'Bộ');

go
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2PL', N'Áo Polo Gucci', '/Content/img/pologucci.jpg',
			          N'Áo polo nam vân nổi G.C cổ bẻ pha màu - phông đẳng cấp', 'admin',250000,10,2,N'Polo',
					  N'Chiếc');

go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2SW', N'Áo Sweater Nam', '/Content/img/sweaternam.jpg',
			          N'Áo Nỉ chân cua oversize +84 LOGO CALIGRAPHY SWEATER CREAM - 84RISING', 'admin',350000,10,2,N'Sweater',
					  N'Chiếc');

go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2QTE', N'Quần dài trẻ em', '/Content/img/quandaitreem.jpg',
			          N'Quần thun dài mịn mát cho bé', 'admin',150000,0,2,N'TOI',
					  N'Chiếc');

go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2OX', N'Quần ống suông', '/Content/img/quanxuong.jpg',
			          N'Quần dài nam Daily Pants - sợi Sorona, nhuộm Cleandye thương hiệu Coolmate', 'admin',250000,0,2,N'Coolmate',
					  N'Chiếc');

go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2SM', N'Áo sơ mi nữ', '/Content/img/sominu.jpg',
			          N'Honeyspot Áo sơ mi Oversized Chất rắn Thả vai Curved Hem', 'admin',270000,0,2,N'SoMi',
					  N'Chiếc');

go
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2QJ', N'Quần Jeans Nam', '/Content/img/son-tung-lisa-1---Copy-1.jpg',
			          N'Quần Jeans Clean Denim dáng Slimfit S2 - thương hiệu Coolmate', 'admin',270000,0,2,N'Jean',
					  N'Chiếc');

go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2BB', N'Áo khoác Bomber', '/Content/img/son-tung-bomber.jpg',
			          N'Áo khoác nam nữ - Bomber jacket YAYSHOP chất liệu nhung gân dày dặn form rộng rãi MISSOUT', 'admin',300000,0,2,N'BB',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2VS', N'Váy suông nữ, đầm suông dài tay cổ tròn thắt nơ chất nhung tăm 3 màu', '/Content/img/vaysuong.jpg',
			          N'Váy dáng suông dài tay cổ tròn thắt nơ chất nhung tăm 3 màu,chất liệu: nhung tăm', 'admin',100000,0,2,N'OEM',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('2TA', N'Quần Tây Âu Nam Co Giãn Nhẹ Dáng Ôm', '/Content/img/quantayaunam.jpg',
			          N'Quần Tây Âu Nam Co Giãn Nhẹ Dáng Ôm, Quần Nam Công Sở Lịch Sự Phù Hợp Mọi Hoàn Cảnh Thương Hiệu Chandi Mã NT334', 'admin',106000,0,2,N'OEM',
					  N'Chiếc');
go

--Túi Xách(MALoaiSP 3) với MASP(3 + tên tắt của sản phẩm )
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('3TXN', N'Túi Xách Nữ Phong Cách Mới Cao Cấp Dễ Phối Đồ', '/Content/img/tuixachnu.jpg',
			          N'Phong cách: túi nhỏ , yếu tố phổ biến: vết khâu xe , phong cách: nhật bản và hàn quốc', 'admin',256200,0,3,N'PU.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('3TĐC', N'Túi đeo chéo nữ 3 ngăn', '/Content/img/tuideocheo.jpg',
			          N'Túi đeo chéo nữ 3 ngăn trần trám khoá sập chống rơi đồ quai đeo da luồn xích phong cách Zuliashop8386', 'admin',88000,0,3,N'PU.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('3MN', N'Túi ví nữ mini ', '/Content/img/tuimini.jpg',
			          N'Túi ví nữ mini đựng điện thoại đeo chéo vai vải nylon chống nước thời trang 00463-3', 'admin',175000,5,3,N'TMU.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('3MC', N'Túi cói Merci đi du lịch đi chơi thời trang TX02', '/Content/img/tuimerci.jpg',
			          N'Chất liệu: Bên ngoài là vải thô. Bên trong được tráng 1 lớp nhựa PP bên trong giúp form túi cứng cáp và
					  chống nước thấm qua túi làm hư đồ bên trong (lưu ý chỉ có túi loại 1 mới có phủ lớp này)', 'admin',47000,0,3,N'OEM.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('3G', N'Túi Tote Nữ Grepaco Xách Vải Bố Canvas', '/Content/img/tuixach.jpg',
			          N'Túi Tote Nữ Grepaco Xách Vải Bố Canvas Cao Cấp In Chữ Đẹp Đeo Chéo Vai Có Khóa Kéo Nhiều Ngăn Dùng Đi Học, L
					  àm Công Sở, Du Lịch Phong Cách Thời Trang Hàn Quốc - Tặng Túi Đựng Mỹ Phẩm', 'admin',134100,0,3,N'GREPACO.',
					  N'Chiếc');
go

--Nón(MALoaiSP 4) với MASP(4 + tên tắt của sản phẩm )
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('4NL', N'Mũ nón lưỡi trai cho trẻ em, nón lưỡi trai cho bé trai bé gái mẫu Vịt cực xinh', '/Content/img/nontreem.jpg',
			          N'Mũ nón lưỡi trai hình chú vịt đáng yêu cho bé trai bé gái. Mũ được làm từ Chất liệu vải an toàn cho bé,
					  lớp vải bên trong mũ mềm mại, với khả năng thấm hút mồ hôi tốt không khô cứng, giúp da đầu bé thoải mái khi đội mũ.
					  Thiết kế ngộ nghĩnh đáng yêu', 'admin',46000,0,4,N' OEM.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('4NCK', N'Mũ nón trẻ em có kính - Mũ phi công trẻ em 2 trong 1', '/Content/img/noncokinh.jpg',
			          N'Kiểu dáng mũ phi công - Mũ nón trẻ em có gắn kính đằng sau (có thể gấp lên nếu không đội),
					  mũ 2 trong một vừa chắn mưa gió vừa chắn bụi', 'admin',140000,10,4,N' OEM.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('4NLT', N'Mũ Lưỡi Trai Nam Phong Cách Lính Mỹ, Nón Kết Nam Lính Mỹ Chiến Thuật
					  Chuyên Đi Phượt Du Lịch Dã Ngoại Dùng Thường Ngày Vải Kaki', '/Content/img/muluoitrai.jpg',
			          N'Sản phẩm mũ lưỡi trai được đóng gói trong hộp đựng cẩn thận , thích hợp làm quà tặng, 
					  được dệt từ vải kaki cao cấp.', 'admin',89000,0,4,N' OEM.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('4NBK', N'MLB - Nón bucket thời trang Check Wool 3AHTCW116-50CRS', '/Content/img/nonbucket.jpg',
			          N'Chất liệu: 76% Cotton, 24% Polyester, kiểu dáng nón bucket hiện đại, 
					  thiết kế lấy cảm hứng từ hiệp hội bóng chày MLB', 'admin',1239000,5,4,N' MLB.',
					  N'Chiếc');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('4NV', N'Mũ vành suôn form rộng style ngầu, phối sọc cho cả nam và nữ MV633', '/Content/img/nonvanh.jpg',
			          N'Mũ vành suôn form rộng style ngầu, phối sọc cho cả nam và nữ MV633.
					  Nếu bạn theo phong cách đường phố cá tính, thích phối đồ kiểu ngầu, chất thì không nên bỏ qua 
					  mẫu nón này. nón dành cho cả nam và nữ nhé.', 'admin',170000,5,4,N' OEM.',
					  N'Chiếc');
go

--SonMoi(MALoaiSP 5) với MASP(5 + tên tắt của sản phẩm )
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('53CE', N'Son Thỏi 3CE Mood Recipe Matte Lip Color - 909 Smoke Rose', '/Content/img/sonrose.jpg',
			          N'Nếu bạn theo phong cách đường phố cá tính, chất thì không nên bỏ qua 
					  mẫu nón này.', 'admin',350000,5,5,N' 3CE.',
					  N'Thỏi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('5DD', N'Son lì 3CE Mood Recipe Matte Lip Color #222 Step And Go - Đỏ Đất', '/Content/img/sondodat.jpg',
			          N'Step And Go chính là gợi ý cho nàng thích tone đỏ đất. Đây dự đoán là thỏi son mang lại cho các nàng những cách
					  trang điểm đa dạng và dễ biến hóa hơn, là thỏi son không lo trầm quá, đậm hay nhạt quá.', 'admin',299000,0,5,N' 3CE.',
					  N'Thỏi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('5H', N'Son Khóa Màu Siêu Dưỡng - Dòng Collagen Boosting Yumeisakura 3.5g', '/Content/img/sonhong.jpg',
			          N'Thành phần chính: Tinh dầu hoa trà, tinh chất hoa anh đào, dầu olive, dầu hạt nho, dầu jojoba, sáp ong, collagen extract.',
					  'admin',200000,0,5,N' YumeiSakura',
					  N'Thỏi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('5SM', N'Son mịn môi giàu độ ẩm Naris Ailus Smooth Lipstick Moisture Rich 3,7g', '/Content/img/sonmin.jpg',
			          N'Son mịn môi giàu độ ẩm Naris Ailus Smooth Lipstick Moisture Rich giúp son lên màu tươi tắn, lâu trôi đồng thời
					  có khả năng dưỡng ẩm cao, phục hồi làn môi khô, nứt nẻ trở nên mềm mượt đầy sức sống. ', 'admin',175000,10,5,N' YNaris Cosmetic.',
					  N'Thỏi');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('5DHT', N'Son thỏi Chioture Hazy Mirror Matte Lipstick chất lì siêu mịn mượt', '/Content/img/sondohoatra.jpg',
			          N'Son thỏi với thiết kế vỏ ngoài sang trọng quý phái, vỏ son và nắp son cực chắc chắn, chất son mỏng mịn giúp đôi môi tươi tắn, 
					  mượt môi không lộ vân môi, không gây khô môi, dễ lên màu và giữ màu chuẩn, với bảng màu phong phú. ', 'admin',169000,1,5,N' CHIOTURE.',
					  N'Thỏi');
go

--Dây chuyền(MALoaiSP 6) với MASP(6 + tên tắt của sản phẩm )

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('6B', N'Dây chuyền nam xích bảng to 12mm cho nam - dây chuyền nam bảng to cá tính cho nam', '/Content/img/daychuyenbang.jpg',
			          N'Dây chuyền nam xích bảng lớn là một trong những phụ kiện trang sức ngày nay có thể nói rằng không thể thiếu đối với các bạn nam khi kết hợp cùng với 
					  những sét đồ làm tôn lên vẻ đẹp lịch lãm và cá tính thời thượng của mình. ', 'admin',290000,1,6,N' OEM.',
					  N'dây');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('6G', N'Dây chuyền hoa cúc G-Dragon unisex - Vòng cổ cực đẹp cho nam & nữ', '/Content/img/daychuyenhoacuc.jpg',
			          N'Chất liệu: titan chống gỉ, màu sắc: trắng dây dài: 60 cmDây chuyền unisex dành cho nam & nữ ', 'admin',28000,0,6,N' OEM.',
					  N'dây');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('6DCN', N'Dây chuyền nữ bạc ta mặt đá tròn MS11', '/Content/img/daychuyennu.jpg',
			          N'VẬT PHẨM PHONG THỦY PHƯỚC KHANG 100% đá tự nhiên, vàng, bạc cao cấp. Shop chuyên tư vấn và kinh doanh trang sức đá tự nhiên, 
					  vàng, bạc cao cấp đặc biệt về vòng tay phong thủy, vòng tay chuỗi hạt đá thiên nhiên siêu xinh xắn.', 'admin',170000,1,6,N' OEM.',
					  N'dây');
go

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('6VTN', N'Vòng đeo tay nữ, lắc tay ngọc trai nhân tạo thiết kế 2 mặt sang chảnh PK19', '/Content/img/vongtaynu.jpg',
			          N'Vòng tay là một trong những mảnh ghép không thể thiếu giúp outfit của các cô nàng trở nên hoàn hảo hơn bao giờ hết.
					  Vòng tay giúp bạn trở nên tự tin, năng động hơn trong bất kì hoạt động nào của cuộc sống.', 'admin',50000,0,6,N' OEM.',
					  N'dây');
go

--Nước hoa(MALoaiSP 7) với MASP(7 + tên tắt của sản phẩm )

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('7NHGC', N'Nước Hoa Nữ Gucci bloom Nettare Di Fiori Eau De Parfum intense 100ml', '/Content/img/nuochoagucci.jpg',
			          N'Gucci Bloom được biết đến như là dòng nước hoa Gucci đầu tiên mà giám đốc sáng tạo Alessandro Michele trực tiếp tham gia sản xuất. 
					  Với nguồn cảm hứng mạnh mẽ đầy nữ quyền, Gucci Bloom Nettare Di Fiori được 
					  sáng tạo ra như một thông điệp làm đẹp rất riêng của mỗi người phụ nữ	.', 'admin',2950000,10,7,N' Gucci',
					  N'chai');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('7NHML', N'Nước Hoa MIni VERSACE EROS FOR MEN Phong Độ Nam Giới 5ml Ý', '/Content/img/nuochoamli.jpg',
			          N'Versace đã tung ra một loại nước hoa mới dành cho nam giới mang tên là Eros, được  lấy cảm hứng và kết nối sâu sắc với thần thoại Hy Lạp. 
					  Mục đích của dòng nước hoa này là khơi gợi và thể hiện sự mạnh mẽ và đam mê. ', 'admin',159000,1,7,N' Versace',
					  N'chai');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('7NHCK', N'Nước Hoa Nam Calvin Klein Ck Be 100ml', '/Content/img/nuochoaCK.jpg',
			          N'Hương đầu: Hoa Oải Hương, Hương lục, Cây bạc hà, Quả quýt hồng, Cây bách xù, Cam Bergamot.Hương giữa: 
					  Hương lục của cỏ xanh, Hoa mộc lan, Hoa phong lan, Hoa lan Nam Phi, Quả đào,
					  Hoa nhài.Hương cuối: Gỗ đàn hương, Hổ phách, Một dược, Xạ hương, Gỗ tuyết tùng, Hương Va ni. ', 'admin',1050000,1,7,N'Calvin Klein',
					  N'chai');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('7LUXE', N'Nước Hoa Cao Cấp Damode Luxe', '/Content/img/nuochoaluxe.jpg',
			          N'Lớp hương cuối là sự kết hợp mùi hương giữa Benzion, Vani, Hoắc hương và gỗ 
					  Tuyết tùng tạo nên một lớp hương phương Đông sang trọng và nổi bật ', 'admin',708000,5,7,N'  Damode',
					  N'chai');
go	

insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai, nhaSanXuat, dvt) 
              values('7Xmen', N'Nước hoa X-men Fire 50ml', '/Content/img/nuochoaXmen.jpg',
			          N'Nước hoa X-men Fire 50ml - Với hương thơm nam tính đầy nội lực từ Blackcurrant và Patchauli,
					  Nước hoa X-men Fire Active Thơm mạnh mẽ giúp lôi cuốn mọi cảm xúc, 
					  khơi nguồn năng lượng phấn khích để chinh phục mọi mục tiêu và giới hạn.', 'admin',209000,5,7,N' X-Men',
					  N'chai');
go	