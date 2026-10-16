
# ERD - Activity Diagram Mapping

## 1. Phan tich khoang trong du lieu

Legacy Database co cac khoang trong:

- Cot status su dung VARCHAR, khong gioi han cac trang thai hop le.
- Thieu security_deposit de luu tien coc.
- Thieu late_fee va damage_fee de ghi nhan cac khoan phi.
- Thieu bang Inspections de luu bien ban kiem tra xe.

## 2. Thiet ke lai co so du lieu

Bang Rentals duoc nang cap voi status ENUM gom BOOKED,
ACTIVE, COMPLETED va CANCELLED.

Cac cot security_deposit, late_fee va damage_fee su dung
DECIMAL(10,2) de luu tru gia tri tien chinh xac.

Bang Inspections luu thoi gian kiem tra, mo ta hu hong
va ten nhan vien kiem tra. Khoa ngoai rental_id lien ket
voi Rentals theo quan he mot-nhieu.

## 3. Vai tro cua damage_fee

damage_fee la truong can thiet de ghi nhan chi phi boi
thuong khi xe bi hu hong. Neu khong co truong nay,
he thong khong the tinh chinh xac tien hoan tra cho khach,
dan den nguy co that thoat doanh thu.

Tien hoan tra duoc tinh theo cong thuc:

security_deposit - late_fee - damage_fee

Rang buoc khoa ngoai ON DELETE RESTRICT giup ngan viec
xoa hop dong khi van con bien ban kiem tra tham chieu den.
