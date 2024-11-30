--TRANSACTIONS AND ROLLBACK
START TRANSACTION;

INSERT INTO anggota (fname_anggota, lname_anggota, alamat_anggota, email_anggota, tanggal_lahir_anggota, riwayat_peminjaman, status_keanggotaan)
VALUES ('John', 'Doe', 'Jl. Contoh No. 123', 'john.doe@example.com', '1999-01-01', '5', 'Aktif');

COMMIT;

--VIEW
CREATE VIEW informasi_peminjaman AS
SELECT
    p.id_peminjaman,
    a.id_anggota,
    a.fname_anggota,
    a.lname_anggota,
    a.email_anggota,
    p.tanggal_peminjaman,
    p.deadline_peminjaman,
    p.status_peminjaman,
    b.judul_buku,
    b.status_buku
FROM
    peminjaman p
JOIN
    anggota a ON p.id_anggota = a.id_anggota
JOIN
    buku b ON p.id_buku = b.id_buku;

--STORED PROCEDURE
DELIMITER //

CREATE PROCEDURE PinjamBuku(
    IN p_id_anggota INT,
    IN p_id_staff INT,
    IN p_id_buku INT
)
BEGIN
    SET @current_date = CURDATE();

    SET @deadline = DATE_ADD(@current_date, INTERVAL 14 DAY);

    UPDATE buku
    SET status_buku = 'Dipinjam'
    WHERE id_buku = p_id_buku;

    INSERT INTO peminjaman (tanggal_peminjaman, deadline_peminjaman, status_peminjaman, id_anggota, id_staff, id_buku)
    VALUES (@current_date, @deadline, 'Dipinjam', p_id_anggota, p_id_staff, p_id_buku);

    SELECT 'Peminjaman berhasil' AS status;
END //

DELIMITER ;

--TRIGGER
DELIMITER //

CREATE TRIGGER SetStatusNonaktif
BEFORE UPDATE ON anggota
FOR EACH ROW
BEGIN
    DECLARE usia INT;

    SET usia = YEAR(CURDATE()) - YEAR(NEW.tanggal_lahir_anggota);

    IF usia >= 35 THEN
        SET NEW.status_keanggotaan = 'Non Aktif';
    END IF;
END //

DELIMITER ;

--STORED FUNCTION
DELIMITER //

CREATE FUNCTION ambil_detail_buku(p_id_buku INT)
RETURNS VARCHAR(255)
BEGIN
    DECLARE result VARCHAR(255);

    SELECT CONCAT('Judul: ', b.judul_buku, ', Kategori: ', db.nama_kategori, ', Genre: ', db.nama_genre, ', Bahasa: ', db.bahasa_buku, ', Jenis Cover: ', db.jenis_cover)
    INTO result
    FROM buku b
    INNER JOIN detail_buku db ON b.id_detail_buku = db.id_detail_buku
    WHERE b.id_buku = p_id_buku;

    RETURN result;
END //

DELIMITER ;

--WHERE
SELECT * FROM buku
WHERE status_buku = 'Tersedia';

--AND OR NOT
SELECT buku.id_buku, buku.judul_buku, buku.deskripsi_buku, buku.status_buku, buku.tahun_terbit,
       buku.id_penulis, buku.id_detail_buku, buku.id_penerbit,
       detail_buku.nama_kategori, detail_buku.nama_genre, detail_buku.bahasa_buku, detail_buku.jenis_cover
FROM buku
INNER JOIN detail_buku ON buku.id_detail_buku = detail_buku.id_detail_buku
WHERE detail_buku.nama_genre = 'Fantasy' AND buku.status_buku = 'Tersedia';

--AND OR NOT
SELECT *
FROM anggota
WHERE NOT (YEAR(CURDATE()) - YEAR(tanggal_lahir_anggota) < 20);

--JOIN 4 TABLE
SELECT 
    Buku.judul_buku,
    Buku.tahun_terbit,
    Penulis.fname_penulis,
    Penulis.lname_penulis,
    Detail_buku.nama_kategori,
    Detail_buku.nama_genre,
    Penerbit.nama_penerbit
FROM Buku
JOIN Penulis ON Buku.id_penulis = Penulis.id_penulis
JOIN Detail_buku ON Buku.id_detail_buku = Detail_buku.id_detail_buku
JOIN Penerbit ON Buku.id_penerbit = Penerbit.id_penerbit;

--ORDER BY
SELECT * FROM buku
ORDER BY tahun_terbit ASC;

--AGGREGATE
SELECT tahun_terbit, COUNT(*) AS jumlah_buku_per_tahun
FROM buku
GROUP BY tahun_terbit;

--SPECIAL OPERATOR
---LIKE
SELECT *
FROM Anggota
WHERE email_anggota LIKE '%amazon.com%';

---IS NULL
SELECT *
FROM Anggota
WHERE riwayat_peminjaman IS NULL;

---BETWEEN
SELECT *
FROM Anggota
WHERE tanggal_lahir_anggota BETWEEN '1990-01-01' AND '2000-12-31';

---IN
SELECT *
FROM Anggota
WHERE status_keanggotaan IN ( 'Aktif');

--GROUP BY
SELECT tanggal_peminjaman, COUNT(*) AS jumlah_peminjaman
FROM peminjaman
GROUP BY tanggal_peminjaman;

--HAVING
SELECT *
FROM detail_buku
HAVING bahasa_buku = 'Inggris' AND jenis_cover = 'Hard Cover';

--SUBQUERY
SELECT nama_kategori, 
       (SELECT COUNT(*) FROM detail_buku WHERE nama_kategori = db.nama_kategori) AS jumlah_buku
FROM detail_buku db
GROUP BY nama_kategori;

--SQL FUNCTIONS
SELECT COUNT(*) AS total_anggota
FROM anggota;









