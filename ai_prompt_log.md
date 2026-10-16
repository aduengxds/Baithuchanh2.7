
# AI Prompt Log - AutoRide Database

## 1. Phan tich Data Gaps

Cau hoi:
Nhung khoang trong du lieu nao trong Legacy Database
khien he thong khong xu ly duoc quy trinh tra xe?

Ket qua:
Thieu tien coc, phi phat tre, phi hu hong va bang
Inspections. Cot status chua gioi han cac gia tri hop le.

## 2. Kieu du lieu tai chinh

Cau hoi:
Tai sao nen dung DECIMAL(10,2) thay vi FLOAT de luu tien?

Ket qua:
DECIMAL luu gia tri thap phan theo co so 10 chinh xac,
phu hop voi cac phep tinh tai chinh. FLOAT co the phat sinh
sai so do cach bieu dien so thuc.

## 3. Thiet ke bang Inspections

Cau hoi:
Tai sao nen tach Inspections thanh bang rieng thay vi
them damage_description vao Rentals?

Ket qua:
Bang rieng cho phep mot hop dong co nhieu bien ban kiem tra,
han che lap lai cot va ho tro truy vet lich su.

## 4. Kiem soat trang thai hop dong

Cau hoi:
Lam sao ngan tao bien ban kiem tra khi hop dong BOOKED?

Ket qua:
Su dung BEFORE INSERT TRIGGER de kiem tra trang thai.
Neu hop dong khong o trang thai ACTIVE, database tu choi
them bien ban.

## 5. Xu ly gia tri NULL khi tinh tien hoan tra

Cau hoi:
Can xu ly NULL nhu the nao trong phep tinh tien hoan tra?

Ket qua:
NULL co the lam ket qua phep tinh tro thanh NULL.
Co the su dung COALESCE(phi, 0) de thay gia tri NULL
bang 0. Schema moi dung NOT NULL va DEFAULT 0 cho cac cot phi.

## 6. Kiem thu nghiep vu

Cau hoi:
Lam sao xac nhan database tinh dung tien hoan tra?

Ket qua:
Khach dong coc 10.000.000 VND, phi phat tre 0 VND,
phi sua chua 2.000.000 VND. Tien hoan tra la
8.000.000 VND.
