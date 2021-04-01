import 'package:capstone_home_doctor/features/health/health_record/views/profile.dart';

List<String> suggestions = [
  'Bệnh Viện Đại Học Y Dược',
  'Bệnh Viện Chợ Rẫy',
  'Bệnh Viện Từ Dũ',
  'Bệnh Viện Nhi Đồng 1',
  'Bệnh Viện Nhi Đồng 2',
  'Bệnh viện Đại học Y Dược TP. HCM',
  'Viện Tim Tp.HCM',
  'Bệnh viện Tim Tâm Đức',
  'Phòng khám Bệnh viện Đại học Y Dược 1',
  'Bệnh viện Đa khoa Quốc tế Vinmec',
  'Phòng khám Đa khoa Saigon Healthcare',
  'Bệnh Viện Thống Nhất',
  'Bệnh Viện Ung Bướu',
  'Bệnh viện truyền máu huyết học',
  'Bệnh viện Nhân dân 115',
  'Bệnh viện Nhân dân Gia Định',
  'Bệnh viện Nguyễn Trãi',
  'Bệnh viện Nguyễn Tri Phương',
  'Bệnh viện Bệnh Nhiệt đới',
  'Viện Y dược học cổ truyền',
  'Bệnh viện Đa khoa Khu vực Thủ Đức'
];
List<String> listType = ['Bệnh tim', 'Các bệnh khác'];
List<TypeFilter> listFilter = [
  TypeFilter(label: 'Hệ thống', value: 0),
  TypeFilter(label: 'Cũ', value: 1),
  TypeFilter(label: 'Tất cả', value: 2),
];
int MORNING = 6;
int NOON = 11;
int AFTERNOON = 16;
int NIGHT = 21;
int MINUTES = 00;
