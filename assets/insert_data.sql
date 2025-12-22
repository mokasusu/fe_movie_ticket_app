--thêm rạp
INSERT INTO cinemas (ma_rap, dia_diem, ten_rap) VALUES
                                                    (11, 'Quận 1, TP. Hồ Chí Minh', 'Galaxy Nguyễn Du'),
                                                    (12, 'Quận 5, TP. Hồ Chí Minh', 'Galaxy Kinh Dương Vương'),
                                                    (13, 'Quận 10, TP. Hồ Chí Minh', 'Galaxy Nguyễn Trãi'),
                                                    (14, 'Quận 6, TP. Hồ Chí Minh', 'Galaxy Phạm Văn Chí'),
                                                    (15, 'Quận Tân Phú, TP. Hồ Chí Minh', 'Galaxy Tân Bình'),
                                                    (16, 'Quận Bình Tân, TP. Hồ Chí Minh', 'Galaxy Bình Tân'),
                                                    (17, 'TP. Đà Nẵng', 'Galaxy Đà Nẵng'),
                                                    (18, 'TP. Cần Thơ', 'Galaxy Cần Thơ'),
                                                    (19, 'TP. Long Xuyên', 'Galaxy Long Xuyên'),
                                                    (20, 'TP. Vũng Tàu', 'Galaxy Vũng Tàu')

--Thể loại
INSERT INTO genre (ma_genre, phan_loai, ten_genre) VALUES
                                                       ('GEN01', NULL, 'Hành động'),
                                                       ('GEN02', NULL, 'Phiêu lưu'),
                                                       ('GEN03', NULL, 'Hoạt hình'),
                                                       ('GEN04', NULL, 'Hài'),
                                                       ('GEN05', NULL, 'Tội phạm'),
                                                       ('GEN06', NULL, 'Tài liệu'),
                                                       ('GEN07', NULL, 'Tâm lý'),
                                                       ('GEN08', NULL, 'Gia đình'),
                                                       ('GEN09', NULL, 'Giả tưởng'),
                                                       ('GEN10', NULL, 'Kinh dị'),
                                                       ('GEN11', NULL, 'Lãng mạn'),
                                                       ('GEN12', NULL, 'Chiến tranh'),
                                                       ('GEN13', NULL, 'Nhạc'),
                                                       ('GEN14', NULL, 'Bí ẩn'),
                                                       ('GEN15', NULL, 'Viễn tưởng'),
                                                       ('GEN16', NULL, 'Lịch sử'),
                                                       ('GEN17', NULL, 'Thể thao'),
                                                       ('GEN18', NULL, 'Chính kịch'),
                                                       ('GEN19', NULL, 'Cổ trang'),
                                                       ('GEN20', NULL, 'Tình cảm');

--phòng chiếu
INSERT INTO rooms (ma_phong, so_ghe, ten_phong, ma_rap) VALUES
-- Rạp 11
(1101, 22, 'P1', 11),
(1102, 22, 'P2', 11),
(1103, 22, 'P3', 11),

-- Rạp 12
(1201, 22, 'P1', 12),
(1202, 22, 'P2', 12),
(1203, 22, 'P3', 12),

-- Rạp 13
(1301, 22, 'P1', 13),
(1302, 22, 'P2', 13),
(1303, 22, 'P3', 13),

-- Rạp 14
(1401, 22, 'P1', 14),
(1402, 22, 'P2', 14),
(1403, 22, 'P3', 14),

-- Rạp 15
(1501, 22, 'P1', 15),
(1502, 22, 'P2', 15),
(1503, 22, 'P3', 15),

-- Rạp 16
(1601, 22, 'P1', 16),
(1602, 22, 'P2', 16),
(1603, 22, 'P3', 16),

-- Rạp 17
(1701, 22, 'P1', 17),
(1702, 22, 'P2', 17),
(1703, 22, 'P3', 17),

-- Rạp 18
(1801, 22, 'P1', 18),
(1802, 22, 'P2', 18),
(1803, 22, 'P3', 18),

-- Rạp 19
(1901, 22, 'P1', 19),
(1902, 22, 'P2', 19),
(1903, 22, 'P3', 19),

-- Rạp 20
(2001, 22, 'P1', 20),
(2002, 22, 'P2', 20),
(2003, 22, 'P3', 20);

INSERT INTO rooms (ma_phong, so_ghe, ten_phong, ma_rap) VALUES
                                                                 (1104, 22, 'P4', 11),
                                                                 (1105, 22, 'P5', 11),
                                                                 (1204, 22, 'P4', 12),
                                                                 (1205, 22, 'P5', 12),
                                                                 (1304, 22, 'P4', 13),
                                                                 (1305, 22, 'P5', 13),
                                                                 (1404, 22, 'P4', 14),
                                                                 (1405, 22, 'P5', 14),
                                                                 (1504, 22, 'P4', 15),
                                                                 (1505, 22, 'P5', 15),
                                                                 (1604, 22, 'P4', 16),
                                                                 (1605, 22, 'P5', 16);
--thêm ghế
INSERT INTO seat_type (ma_seat_type, gia, ten_seat_type) VALUES
-- Hàng A (Normal)
('A1', 45000, 'normal'), ('A2', 45000, 'normal'), ('A3', 45000, 'normal'), ('A4', 45000, 'normal'),
('A5', 45000, 'normal'), ('A6', 45000, 'normal'), ('A7', 45000, 'normal'), ('A8', 45000, 'normal'),

-- Hàng B (Normal)
('B1', 45000, 'normal'), ('B2', 45000, 'normal'), ('B3', 45000, 'normal'), ('B4', 45000, 'normal'),
('B5', 45000, 'normal'), ('B6', 45000, 'normal'), ('B7', 45000, 'normal'), ('B8', 45000, 'normal'),

-- Hàng C (Normal)
('C1', 45000, 'normal'), ('C2', 45000, 'normal'), ('C3', 45000, 'normal'), ('C4', 45000, 'normal'),
('C5', 45000, 'normal'), ('C6', 45000, 'normal'), ('C7', 45000, 'normal'), ('C8', 45000, 'normal'),

-- Hàng D (VIP)
('D1', 70000, 'vip'), ('D2', 70000, 'vip'), ('D3', 70000, 'vip'), ('D4', 70000, 'vip'),
('D5', 70000, 'vip'), ('D6', 70000, 'vip'), ('D7', 70000, 'vip'), ('D8', 70000, 'vip'),

-- Hàng E (VIP)
('E1', 70000, 'vip'), ('E2', 70000, 'vip'), ('E3', 70000, 'vip'), ('E4', 70000, 'vip'),
('E5', 70000, 'vip'), ('E6', 70000, 'vip'), ('E7', 70000, 'vip'), ('E8', 70000, 'vip'),

-- Hàng F (Couple - Chỉ có 1 đến 4)
('F1', 120000, 'couple'), ('F2', 120000, 'couple'), ('F3', 120000, 'couple'), ('F4', 120000, 'couple');

--thêm phimINSERT INTO film (
    ma_phim, anh_poster_doc, anh_poster_ngang, dao_dien, dien_vien, do_tuoi,
    mo_ta, ngay_cong_chieu, ngay_kt_chieu, ten_phim, thoi_luong,
    trailer_url, trang_thai
) VALUES
-- P001
(
    'P001',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/5_cm_tren_giay.png',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/5_cm_tren_giay_n.jpg',
    'Shinkai Makoto',
    '',
    13,
    'Câu chuyện cảm động về Takaki và Akari, đôi bạn thuở thiếu thời dần bị chia cắt bởi thời gian và khoảng cách. Qua ba giai đoạn khác nhau trong cuộc đời, hành trình khắc họa những ký ức, cuộc hội ngộ và sự xa cách của cặp đôi, với hình ảnh hoa anh đào rơi – 5cm/giây – như ẩn dụ cho tình yêu mong manh và thoáng chốc của tuổi trẻ.',
    '2025-12-05',
    NULL,
    '5 centimet trên giây',
    76,
    'https://youtu.be/PjAcCzgg3pw?si=lF1ZG9XoC8RUORTl',
    'NOW_SHOWING'
),

-- P002
(
    'P002',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/chu_thuat_hoi_chien_bien_co_shibuya_tu_diet_hon_du.jpg',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/chu_thuat_hoi_chien_bien_co_shibuya_tu_diet_hoi_du_n.jpg',
    'Shouta Goshozono',
    '',
    13,
    'Sau bao ngày chờ đợi, Đại Chiến Shibuya cuối cùng cũng xuất hiện trên màn ảnh rộng, gom trọn những khoảnh khắc nghẹt thở nhất thành một cú nổ đúng nghĩa. Không chỉ tái hiện toàn bộ cơn ác mộng tại Shibuya, bộ phim còn hé lộ những bí mật then chốt và mở màn cho trò chơi sinh tử “Tử Diệt Hồi Du” đầy kịch tính và mãn nhãn.',
    '2025-12-05',
    NULL,
    'Chú Thuật Hồi Chiến: Biến Cố Shibuya x Tử Diệt Hồi Du - The Movie',
    88,
    'https://youtu.be/EWKm0lolQRM?si=HynIEp9Y0I_qQnlg',
    'NOW_SHOWING'
),

-- P003
(
    'P003',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/hoang_tu_quy.png',
    '',
    'Trần Hữu Tấn',
    'Anh Tú Atus, Lương Thế Thành, Hoàng Linh Chi, Huỳnh Thanh Trực, Rima Thanh Vy, Lê Hà Phương, Duy Luân,...',
    18,
    'Hoàng Tử Quỷ xoay quanh Thân Đức – một hoàng tử được sinh ra nhờ tà thuật. Trốn thoát khỏi cung cấm, Thân Đức tham vọng giải thoát Quỷ Xương Cuồng khỏi Ải Mắt Người để khôi phục Xương Cuồng Giáo. Nhưng kế hoạch của Thân Đức chỉ thành hiện thực khi hắn có đủ cả hai nguyên liệu – Du Hồn Giả và Bạch Hổ Nguyên Âm.',
    '2025-12-05',
    NULL,
    'Hoàng Tử Quỷ',
    117,
    'https://youtu.be/8sN-kdDxPSM?si=a7jpguM_6Fy4mFI3',
    'NOW_SHOWING'
),

-- P004
(
    'P004',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/phi_vu_dong_troi_2.png',
    '',
    'Jared Bush, Byron Howard',
    'Jason Bateman, Quinta Brunson, Fortune Feimster',
    0,
    'ZOOTOPIA 2 trở lại sau 9 năm. Đu OTP Nick & Judy chuẩn bị 28.11.2025 này ra rạp nhé.',
    '2025-11-28',
    NULL,
    'Phi Vụ Động Trời 2',
    107,
    'https://youtu.be/c6qXf2Zg8K8?si=G90iUZL2AishRfr_',
    'NOW_SHOWING'
),

-- P005
(
    'P005',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/quan_ky_nam.jpg',
    '',
    'Lê Nhật Quang (Leon Le)',
    'Liên Bỉnh Phát, Đỗ Thị Hải Yến, Trần Thế Mạnh, Ngô Hồng Ngọc, Lý Kiều Hạnh, Lê Văn Thân,...',
    16,
    'Khang chuyển vào sống tại khu chung cư cũ và kết thân với Kỳ Nam – một góa phụ nổi tiếng trong giới nữ công gia chánh. Một biến cố khiến Kỳ Nam mất khả năng làm cơm tháng và Khang quyết định giúp đỡ, mở ra mối quan hệ đầy cảm xúc giữa hai con người cô độc.',
    '2025-11-28',
    NULL,
    'Quán Kỳ Nam',
    135,
    'https://youtu.be/9ZHWzsyq9NU?si=tr19qmX8XG5rpYTD',
    'NOW_SHOWING'
),

-- P006
(
    'P006',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/truy_tim_long_dien_huong.jpg',
    '',
    'Dương Minh Chiến',
    'Quang Tuấn, Ma Ran Đô, Nguyên Thảo, Hoàng Tóc Dài, NSND Thanh Nam,...',
    16,
    'Báu vật làng biển Long Diên Hương bị đánh cắp, mở ra hành trình truy tìm đầy kịch tính. Bộ phim mang đến võ thuật mãn nhãn, tiếng cười và giá trị nhân văn của con người làng chài.',
    '2025-11-14',
    NULL,
    'Truy Tìm Long Diên Hương',
    103,
    'https://youtu.be/aTVcY0QlWAE?si=9EO2vr-UYVUPpbfI',
    'NOW_SHOWING'
);

INSERT INTO film (
    ma_phim, anh_poster_doc, anh_poster_ngang, dao_dien, dien_vien, do_tuoi,
    mo_ta, ngay_cong_chieu, ngay_kt_chieu, ten_phim, thoi_luong,
    trailer_url, trang_thai
) VALUES
(
 'P007','https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/em_se_nho_anh.png
', '', 'Lynne Ramsay', 'Jennifer Lawrence; Robert Pattinson; Sissy Spacek', 18, 'Một cặp đôi trẻ đầy tình yêu và hy vọng (Grace và Jackson) rời New York để chuyển đến ngôi nhà thừa kế tại vùng quê yên tĩnh. Giữa không gian cô lập, Grace vật lộn với chứng trầm cảm sau sinh và cố gắng tìm lại chính mình trong vai trò người mẹ. Nhưng khi cô dần rơi vào trạng thái rạn vỡ và hỗn loạn, đó không phải vì yếu đuối, mà chính nhờ trí tưởng tượng, nghị lực và sức sống mãnh liệt hoang dã, cô tìm thấy lại con người thật của mình.',
 '2025-12-26', NULL, 'Em Sẽ Khử Anh', 118, 'https://youtu.be/5ijfhBt40ck?si=bLosKPCBoFariDjb','UPCOMING'
),
(
 'P008', 'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/mui_pho.png
', '','Minh Beta', 'Nghệ sỹ Xuân Hinh - Diễn viên Thu Trang - Nghệ sỹ Thanh Thanh Hiền - Nghệ sỹ Quốc Tuấn - Bảo Nam - Hà Hương - Thanh Hương - Chu Mạnh Cường - Tiến Lộc',0, 'Câu chuyện về sự xung đột thế hệ và những va chạm giữa quan niệm cũ và lối sống hiện đại, xoay quanh món Phở - biểu tượng ẩm thực Việt. Đằng sau những mâu thuẫn và tranh cãi ấy, từng bí mật dần được hé lộ, mở ra hành trình tìm lại sự ấm áp của tình thân qua những tình tiết hài hước, dí dỏm và đầy duyên dáng.', '2026-02-17', NULL
,'Mùi Phở', 106,'https://youtu.be/3ZlouKbVets?si=_FurD9UT3Uvc1PI5','UPCOMING'
);

INSERT INTO film (
    ma_phim, anh_poster_doc, anh_poster_ngang, dao_dien, dien_vien,
    do_tuoi, mo_ta, ngay_cong_chieu, ngay_kt_chieu, ten_phim,
    thoi_luong, trailer_url, trang_thai
) VALUES
-- ====================== P101 ======================
(
    'P101',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/ended_dune2.jpg',
    '',
    'Denis Villeneuve',
    'Timothée Chalamet; Zendaya; Rebecca Ferguson',
    13,
    'Paul Atreides liên minh với người Fremen để trả thù những kẻ đã phá hủy gia đình mình và bảo vệ tương lai Arrakis.',
    '2024-03-01',
    '2024-05-15',
    'Dune: Part Two',
    166,
    'https://youtu.be/Way9Dexny3w',
    'ENDED'
),

-- ====================== P102 ======================
(
    'P102',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/ended_godzilla_kong.jpg',
    '',
    'Adam Wingard',
    'Rebecca Hall; Dan Stevens; Brian Tyree Henry',
    16,
    'Godzilla và Kong hợp tác chống lại mối đe dọa cổ xưa đe dọa toàn bộ Trái Đất.',
    '2024-04-01',
    '2024-06-10',
    'Godzilla x Kong: The New Empire',
    115,
    'https://youtu.be/lV1OOlGwExM',
    'ENDED'
),

-- ====================== P103 ======================
(
    'P103',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/ended_inside_out2.jpg',
    '',
    'Kelsey Mann',
    'Amy Poehler; Maya Hawke; Kensington Tallman',
    0,
    'Riley bước vào tuổi thiếu niên với những cảm xúc mới đầy hỗn loạn, thử thách sự cân bằng của các cảm xúc cũ.',
    '2024-06-14',
    '2024-09-01',
    'Inside Out 2',
    96,
    'https://youtu.be/LEjhY15eCx0',
    'ENDED'
),

-- ====================== P104 ======================
(
    'P104',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/ended_kungfu_panda4.jpg',
    '',
    'Mike Mitchell',
    'Jack Black; Awkwafina; Viola Davis',
    0,
    'Po đối mặt với kẻ địch mới và tìm kiếm người kế vị để trở thành Thần Long Đại Hiệp thực sự.',
    '2024-03-08',
    '2024-05-20',
    'Kung Fu Panda 4',
    94,
    'https://youtu.be/_inKs4eeHiI',
    'ENDED'
),

-- ====================== P105 ======================
(
    'P105',
    'https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/main/posters/ended_spiderman.jpg',
    '',
    'Jon Watts',
    'Tom Holland; Zendaya; Jacob Batalon',
    13,
    'Peter Parker đối đầu kẻ thù mới trong khi phải bảo vệ danh tính và những người thân yêu.',
    '2023-12-15',
    '2024-03-01',
    'Spider-Man: No Way Home',
    148,
    'https://youtu.be/rt-2cxAiPJk',
    'ENDED'
);

--suất chiếu
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
-- Ngày 1: 18/12/2025
( '2025-12-18 15:00:00.000000', NULL, 12, 'P003', 1203),
( '2025-12-18 20:00:00.000000', NULL, 13, 'P003', 1301),
( '2025-12-18 09:45:00.000000', NULL, 14, 'P004', 1402),
( '2025-12-18 14:20:00.000000', NULL, 15, 'P004', 1503),
( '2025-12-18 18:40:00.000000', NULL, 16, 'P004', 1601),
( '2025-12-18 10:00:00.000000', NULL, 11, 'P005', 1103),
( '2025-12-18 13:50:00.000000', NULL, 12, 'P005', 1201),
( '2025-12-18 18:30:00.000000', NULL, 13, 'P005', 1302),
( '2025-12-18 09:00:00.000000', NULL, 14, 'P006', 1403),
( '2025-12-18 14:00:00.000000', NULL, 15, 'P006', 1501),
( '2025-12-18 19:00:00.000000', NULL, 16, 'P006', 1602),

-- Ngày 2: 19/12/2025
('2025-12-19 15:00:00.000000', NULL, 12, 'P003', 1203),
('2025-12-19 20:00:00.000000', NULL, 13, 'P003', 1301),
('2025-12-19 09:45:00.000000', NULL, 14, 'P004', 1402),
('2025-12-19 14:20:00.000000', NULL, 15, 'P004', 1503),
('2025-12-19 18:40:00.000000', NULL, 16, 'P004', 1601),
('2025-12-19 10:00:00.000000', NULL, 11, 'P005', 1103),
('2025-12-19 13:50:00.000000', NULL, 12, 'P005', 1201),
('2025-12-19 18:30:00.000000', NULL, 13, 'P005', 1302),
('2025-12-19 09:00:00.000000', NULL, 14, 'P006', 1403),
('2025-12-19 14:00:00.000000', NULL, 15, 'P006', 1501),
('2025-12-19 19:00:00.000000', NULL, 16, 'P006', 1602),

-- Ngày 3: 20/12/2025
('2025-12-20 15:00:00.000000', NULL, 12, 'P003', 1203),
('2025-12-20 20:00:00.000000', NULL, 13, 'P003', 1301),
('2025-12-20 09:45:00.000000', NULL, 14, 'P004', 1402),
('2025-12-20 14:20:00.000000', NULL, 15, 'P004', 1503),
('2025-12-20 18:40:00.000000', NULL, 16, 'P004', 1601),
('2025-12-20 10:00:00.000000', NULL, 11, 'P005', 1103),
('2025-12-20 13:50:00.000000', NULL, 12, 'P005', 1201),
('2025-12-20 18:30:00.000000', NULL, 13, 'P005', 1302),
('2025-12-20 09:00:00.000000', NULL, 14, 'P006', 1403),
('2025-12-20 14:00:00.000000', NULL, 15, 'P006', 1501),
('2025-12-20 19:00:00.000000', NULL, 16, 'P006', 1602),

-- Ngày 4: 21/12/2025
('2025-12-21 15:00:00.000000', NULL, 12, 'P003', 1203),
('2025-12-21 20:00:00.000000', NULL, 13, 'P003', 1301),
('2025-12-21 09:45:00.000000', NULL, 14, 'P004', 1402),
('2025-12-21 14:20:00.000000', NULL, 15, 'P004', 1503),
('2025-12-21 18:40:00.000000', NULL, 16, 'P004', 1601),
('2025-12-21 10:00:00.000000', NULL, 11, 'P005', 1103),
('2025-12-21 13:50:00.000000', NULL, 12, 'P005', 1201),
('2025-12-21 18:30:00.000000', NULL, 13, 'P005', 1302),
('2025-12-21 09:00:00.000000', NULL, 14, 'P006', 1403),
('2025-12-21 14:00:00.000000', NULL, 15, 'P006', 1501),
('2025-12-21 19:00:00.000000', NULL, 16, 'P006', 1602),

-- Ngày 5: 22/12/2025
('2025-12-22 15:00:00.000000', NULL, 12, 'P003', 1203),
('2025-12-22 20:00:00.000000', NULL, 13, 'P003', 1301),
('2025-12-22 09:45:00.000000', NULL, 14, 'P004', 1402),
('2025-12-22 14:20:00.000000', NULL, 15, 'P004', 1503),
('2025-12-22 18:40:00.000000', NULL, 16, 'P004', 1601),
('2025-12-22 10:00:00.000000', NULL, 11, 'P005', 1103),
('2025-12-22 13:50:00.000000', NULL, 12, 'P005', 1201),
('2025-12-22 18:30:00.000000', NULL, 13, 'P005', 1302),
('2025-12-22 09:00:00.000000', NULL, 14, 'P006', 1403),
('2025-12-22 14:00:00.000000', NULL, 15, 'P006', 1501),
('2025-12-22 19:00:00.000000', NULL, 16, 'P006', 1602);

-- NGÀY 25/12/2025 (Giáng sinh - 30 suất)
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
                                                                                 ('2025-12-25 09:00:00', NULL, 11, 'P001', 1101),
                                                                                 ('2025-12-25 09:15:00', NULL, 12, 'P002', 1201),
                                                                                 ('2025-12-25 09:30:00', NULL, 13, 'P003', 1301),
                                                                                 ('2025-12-25 09:45:00', NULL, 14, 'P004', 1401),
                                                                                 ('2025-12-25 10:00:00', NULL, 15, 'P005', 1501),
                                                                                 ('2025-12-25 10:15:00', NULL, 16, 'P006', 1601),
                                                                                 ('2025-12-25 11:30:00', NULL, 11, 'P002', 1102),
                                                                                 ('2025-12-25 11:45:00', NULL, 12, 'P003', 1202),
                                                                                 ('2025-12-25 12:00:00', NULL, 13, 'P004', 1302),
                                                                                 ('2025-12-25 12:15:00', NULL, 14, 'P005', 1402),
                                                                                 ('2025-12-25 12:30:00', NULL, 15, 'P006', 1502),
                                                                                 ('2025-12-25 12:45:00', NULL, 16, 'P001', 1602),
                                                                                 ('2025-12-25 14:00:00', NULL, 11, 'P003', 1103),
                                                                                 ('2025-12-25 14:15:00', NULL, 12, 'P004', 1203),
                                                                                 ('2025-12-25 14:30:00', NULL, 13, 'P005', 1303),
                                                                                 ('2025-12-25 14:45:00', NULL, 14, 'P006', 1403),
                                                                                 ('2025-12-25 15:00:00', NULL, 15, 'P001', 1503),
                                                                                 ('2025-12-25 15:15:00', NULL, 16, 'P002', 1603),
                                                                                 ('2025-12-25 18:00:00', NULL, 11, 'P004', 1104),
                                                                                 ('2025-12-25 18:15:00', NULL, 12, 'P005', 1204),
                                                                                 ('2025-12-25 18:30:00', NULL, 13, 'P006', 1304),
                                                                                 ('2025-12-25 18:45:00', NULL, 14, 'P001', 1404),
                                                                                 ('2025-12-25 19:00:00', NULL, 15, 'P002', 1504),
                                                                                 ('2025-12-25 19:15:00', NULL, 16, 'P003', 1604),
                                                                                 ('2025-12-25 20:30:00', NULL, 11, 'P005', 1105),
                                                                                 ('2025-12-25 20:45:00', NULL, 12, 'P006', 1205),
                                                                                 ('2025-12-25 21:00:00', NULL, 13, 'P001', 1305),
                                                                                 ('2025-12-25 21:15:00', NULL, 14, 'P002', 1405),
                                                                                 ('2025-12-25 21:30:00', NULL, 15, 'P003', 1505),
                                                                                 ('2025-12-25 21:45:00', NULL, 16, 'P004', 1605);

-- NGÀY 26/12/2025 (30 suất)
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
                                                                                 ('2025-12-26 09:00:00', NULL, 11, 'P006', 1101),
                                                                                 ('2025-12-26 09:15:00', NULL, 12, 'P001', 1201),
                                                                                 ('2025-12-26 09:30:00', NULL, 13, 'P002', 1301),
                                                                                 ('2025-12-26 09:45:00', NULL, 14, 'P003', 1401),
                                                                                 ('2025-12-26 10:00:00', NULL, 15, 'P004', 1501),
                                                                                 ('2025-12-26 10:15:00', NULL, 16, 'P005', 1601),
                                                                                 ('2025-12-26 11:30:00', NULL, 11, 'P001', 1102),
                                                                                 ('2025-12-26 11:45:00', NULL, 12, 'P002', 1202),
                                                                                 ('2025-12-26 12:00:00', NULL, 13, 'P003', 1302),
                                                                                 ('2025-12-26 12:15:00', NULL, 14, 'P004', 1402),
                                                                                 ('2025-12-26 12:30:00', NULL, 15, 'P005', 1502),
                                                                                 ('2025-12-26 12:45:00', NULL, 16, 'P006', 1602),
                                                                                 ('2025-12-26 14:00:00', NULL, 11, 'P002', 1103),
                                                                                 ('2025-12-26 14:15:00', NULL, 12, 'P003', 1203),
                                                                                 ('2025-12-26 14:30:00', NULL, 13, 'P004', 1303),
                                                                                 ('2025-12-26 14:45:00', NULL, 14, 'P005', 1403),
                                                                                 ('2025-12-26 15:00:00', NULL, 15, 'P006', 1503),
                                                                                 ('2025-12-26 15:15:00', NULL, 16, 'P001', 1603),
                                                                                 ('2025-12-26 18:00:00', NULL, 11, 'P003', 1104),
                                                                                 ('2025-12-26 18:15:00', NULL, 12, 'P004', 1204),
                                                                                 ('2025-12-26 18:30:00', NULL, 13, 'P005', 1304),
                                                                                 ('2025-12-26 18:45:00', NULL, 14, 'P006', 1404),
                                                                                 ('2025-12-26 19:00:00', NULL, 15, 'P001', 1504),
                                                                                 ('2025-12-26 19:15:00', NULL, 16, 'P002', 1604),
                                                                                 ('2025-12-26 20:30:00', NULL, 11, 'P004', 1105),
                                                                                 ('2025-12-26 20:45:00', NULL, 12, 'P005', 1205),
                                                                                 ('2025-12-26 21:00:00', NULL, 13, 'P006', 1305),
                                                                                 ('2025-12-26 21:15:00', NULL, 14, 'P001', 1405),
                                                                                 ('2025-12-26 21:30:00', NULL, 15, 'P002', 1505),
                                                                                 ('2025-12-26 21:45:00', NULL, 16, 'P003', 1605);
-- NGÀY 27/12/2025 (30 suất)
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
                                                                                 ('2025-12-27 09:00:00', NULL, 11, 'P005', 1101),
                                                                                 ('2025-12-27 09:15:00', NULL, 12, 'P006', 1201),
                                                                                 ('2025-12-27 09:30:00', NULL, 13, 'P001', 1301),
                                                                                 ('2025-12-27 09:45:00', NULL, 14, 'P002', 1401),
                                                                                 ('2025-12-27 10:00:00', NULL, 15, 'P003', 1501),
                                                                                 ('2025-12-27 10:15:00', NULL, 16, 'P004', 1601),
                                                                                 ('2025-12-27 11:30:00', NULL, 11, 'P006', 1102),
                                                                                 ('2025-12-27 11:45:00', NULL, 12, 'P001', 1202),
                                                                                 ('2025-12-27 12:00:00', NULL, 13, 'P002', 1302),
                                                                                 ('2025-12-27 12:15:00', NULL, 14, 'P003', 1402),
                                                                                 ('2025-12-27 12:30:00', NULL, 15, 'P004', 1502),
                                                                                 ('2025-12-27 12:45:00', NULL, 16, 'P005', 1602),
                                                                                 ('2025-12-27 14:00:00', NULL, 11, 'P001', 1103),
                                                                                 ('2025-12-27 14:15:00', NULL, 12, 'P002', 1203),
                                                                                 ('2025-12-27 14:30:00', NULL, 13, 'P003', 1303),
                                                                                 ('2025-12-27 14:45:00', NULL, 14, 'P004', 1403),
                                                                                 ('2025-12-27 15:00:00', NULL, 15, 'P005', 1503),
                                                                                 ('2025-12-27 15:15:00', NULL, 16, 'P006', 1603),
                                                                                 ('2025-12-27 18:00:00', NULL, 11, 'P002', 1104),
                                                                                 ('2025-12-27 18:15:00', NULL, 12, 'P003', 1204),
                                                                                 ('2025-12-27 18:30:00', NULL, 13, 'P004', 1304),
                                                                                 ('2025-12-27 18:45:00', NULL, 14, 'P005', 1404),
                                                                                 ('2025-12-27 19:00:00', NULL, 15, 'P006', 1504),
                                                                                 ('2025-12-27 19:15:00', NULL, 16, 'P001', 1604),
                                                                                 ('2025-12-27 20:30:00', NULL, 11, 'P003', 1105),
                                                                                 ('2025-12-27 20:45:00', NULL, 12, 'P004', 1205),
                                                                                 ('2025-12-27 21:00:00', NULL, 13, 'P005', 1305),
                                                                                 ('2025-12-27 21:15:00', NULL, 14, 'P006', 1405),
                                                                                 ('2025-12-27 21:30:00', NULL, 15, 'P001', 1505),
                                                                                 ('2025-12-27 21:45:00', NULL, 16, 'P002', 1605);

-- NGÀY 28/12/2025 (30 suất)
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
                                                                                 ('2025-12-28 09:00:00', NULL, 11, 'P004', 1101),
                                                                                 ('2025-12-28 09:15:00', NULL, 12, 'P005', 1201),
                                                                                 ('2025-12-28 09:30:00', NULL, 13, 'P006', 1301),
                                                                                 ('2025-12-28 09:45:00', NULL, 14, 'P001', 1401),
                                                                                 ('2025-12-28 10:00:00', NULL, 15, 'P002', 1501),
                                                                                 ('2025-12-28 10:15:00', NULL, 16, 'P003', 1601),
                                                                                 ('2025-12-28 11:30:00', NULL, 11, 'P005', 1102),
                                                                                 ('2025-12-28 11:45:00', NULL, 12, 'P006', 1202),
                                                                                 ('2025-12-28 12:00:00', NULL, 13, 'P001', 1302),
                                                                                 ('2025-12-28 12:15:00', NULL, 14, 'P002', 1402),
                                                                                 ('2025-12-28 12:30:00', NULL, 15, 'P003', 1502),
                                                                                 ('2025-12-28 12:45:00', NULL, 16, 'P004', 1602),
                                                                                 ('2025-12-28 14:00:00', NULL, 11, 'P006', 1103),
                                                                                 ('2025-12-28 14:15:00', NULL, 12, 'P001', 1203),
                                                                                 ('2025-12-28 14:30:00', NULL, 13, 'P002', 1303),
                                                                                 ('2025-12-28 14:45:00', NULL, 14, 'P003', 1403),
                                                                                 ('2025-12-28 15:00:00', NULL, 15, 'P004', 1503),
                                                                                 ('2025-12-28 15:15:00', NULL, 16, 'P005', 1603),
                                                                                 ('2025-12-28 18:00:00', NULL, 11, 'P001', 1104),
                                                                                 ('2025-12-28 18:15:00', NULL, 12, 'P002', 1204),
                                                                                 ('2025-12-28 18:30:00', NULL, 13, 'P003', 1304),
                                                                                 ('2025-12-28 18:45:00', NULL, 14, 'P004', 1404),
                                                                                 ('2025-12-28 19:00:00', NULL, 15, 'P005', 1504),
                                                                                 ('2025-12-28 19:15:00', NULL, 16, 'P006', 1604),
                                                                                 ('2025-12-28 20:30:00', NULL, 11, 'P002', 1105),
                                                                                 ('2025-12-28 20:45:00', NULL, 12, 'P003', 1205),
                                                                                 ('2025-12-28 21:00:00', NULL, 13, 'P004', 1305),
                                                                                 ('2025-12-28 21:15:00', NULL, 14, 'P005', 1405),
                                                                                 ('2025-12-28 21:30:00', NULL, 15, 'P006', 1505),
                                                                                 ('2025-12-28 21:45:00', NULL, 16, 'P001', 1605);
INSERT INTO showtimes (tg_bat_dau, tg_ket_thuc, cinema_id, film_id, room_id) VALUES
-- Khung giờ sáng sớm
('2025-12-25 07:00:00', NULL, 11, 'P001', 1101),
('2025-12-25 07:15:00', NULL, 12, 'P002', 1201),
('2025-12-25 07:30:00', NULL, 13, 'P003', 1301),
('2025-12-25 07:45:00', NULL, 14, 'P004', 1401),
('2025-12-25 08:00:00', NULL, 15, 'P005', 1501),
('2025-12-25 08:15:00', NULL, 16, 'P006', 1601),
('2025-12-25 08:30:00', NULL, 11, 'P002', 1102),
('2025-12-25 08:45:00', NULL, 12, 'P003', 1202),
-- Khung giờ sáng muộn (09:00 – 12:45)
('2025-12-25 09:00:00', NULL, 11, 'P001', 1101),
('2025-12-25 09:15:00', NULL, 12, 'P002', 1201),
('2025-12-25 09:30:00', NULL, 13, 'P003', 1301),
('2025-12-25 09:45:00', NULL, 14, 'P004', 1401),
('2025-12-25 10:00:00', NULL, 15, 'P005', 1501),
('2025-12-25 10:15:00', NULL, 16, 'P006', 1601),
('2025-12-25 11:30:00', NULL, 11, 'P002', 1102),
('2025-12-25 11:45:00', NULL, 12, 'P003', 1202),
('2025-12-25 12:00:00', NULL, 13, 'P004', 1302),
('2025-12-25 12:15:00', NULL, 14, 'P005', 1402),
('2025-12-25 12:30:00', NULL, 15, 'P006', 1502),
('2025-12-25 12:45:00', NULL, 16, 'P001', 1602),
-- Khung giờ chiều (13:00 – 17:45)
('2025-12-25 13:00:00', NULL, 11, 'P003', 1103),
('2025-12-25 13:15:00', NULL, 12, 'P004', 1203),
('2025-12-25 13:30:00', NULL, 13, 'P005', 1303),
('2025-12-25 13:45:00', NULL, 14, 'P006', 1403),
('2025-12-25 14:00:00', NULL, 11, 'P003', 1103),
('2025-12-25 14:15:00', NULL, 12, 'P004', 1203),
('2025-12-25 14:30:00', NULL, 13, 'P005', 1303),
('2025-12-25 14:45:00', NULL, 14, 'P006', 1403),
('2025-12-25 15:00:00', NULL, 15, 'P001', 1503),
('2025-12-25 15:15:00', NULL, 16, 'P002', 1603),
('2025-12-25 16:00:00', NULL, 11, 'P003', 1103),
('2025-12-25 16:15:00', NULL, 12, 'P004', 1203),
('2025-12-25 16:30:00', NULL, 13, 'P005', 1303),
('2025-12-25 16:45:00', NULL, 14, 'P006', 1403),
('2025-12-25 17:00:00', NULL, 15, 'P001', 1503),
('2025-12-25 17:15:00', NULL, 16, 'P002', 1603),
('2025-12-25 17:30:00', NULL, 11, 'P003', 1103),
('2025-12-25 17:45:00', NULL, 12, 'P004', 1203),
-- Khung giờ tối (18:00 – 23:00)
('2025-12-25 18:00:00', NULL, 11, 'P004', 1104),
('2025-12-25 18:15:00', NULL, 12, 'P005', 1204),
('2025-12-25 18:30:00', NULL, 13, 'P006', 1304),
('2025-12-25 18:45:00', NULL, 14, 'P001', 1404),
('2025-12-25 19:00:00', NULL, 15, 'P002', 1504),
('2025-12-25 19:15:00', NULL, 16, 'P003', 1604),
('2025-12-25 20:30:00', NULL, 11, 'P005', 1105),
('2025-12-25 20:45:00', NULL, 12, 'P006', 1205),
('2025-12-25 21:00:00', NULL, 13, 'P001', 1305),
('2025-12-25 21:15:00', NULL, 14, 'P002', 1405),
('2025-12-25 21:30:00', NULL, 15, 'P003', 1505),
('2025-12-25 21:45:00', NULL, 16, 'P004', 1605),
('2025-12-25 22:00:00', NULL, 11, 'P005', 1105),
('2025-12-25 22:15:00', NULL, 12, 'P006', 1205),
('2025-12-25 22:30:00', NULL, 13, 'P001', 1305),
('2025-12-25 22:45:00', NULL, 14, 'P002', 1405),
('2025-12-25 23:00:00', NULL, 15, 'P003', 1505);


