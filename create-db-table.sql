-- Membuat database
CREATE DATABASE IF NOT EXISTS LibraryZone;

-- Menggunakan database yang baru dibuat
USE LibraryZone;

-- Tabel Anggota
CREATE TABLE IF NOT EXISTS Anggota (
    id_anggota INT PRIMARY KEY,
    fname_anggota VARCHAR(255),
    lname_anggota VARCHAR(255),
    alamat_anggota VARCHAR(255),
    email_anggota VARCHAR(255),
    tanggal_lahir_anggota VARCHAR(10),
    riwayat_peminjaman VARCHAR(255),
    status_keanggotaan VARCHAR(50)
);

-- Tabel Staff
CREATE TABLE IF NOT EXISTS Staff (
    id_staff INT PRIMARY KEY,
    fname_staff VARCHAR(255),
    lname_staff VARCHAR(255),
    uname_staff VARCHAR(50),
    password_staff VARCHAR(50),
    email_staff VARCHAR(255),
    no_telp_staff VARCHAR(15)
);

-- Tabel Penulis
CREATE TABLE IF NOT EXISTS Penulis (
    id_penulis INT PRIMARY KEY,
    fname_penulis VARCHAR(255),
    lname_penulis VARCHAR(255),
    email_penulis VARCHAR(255),
    alamat_penulis VARCHAR(255),
    no_telp_penulis VARCHAR(15)
);


-- Tabel Detail_buku
CREATE TABLE IF NOT EXISTS Detail_buku (
    id_detail_buku INT PRIMARY KEY,
    nama_kategori VARCHAR(50),
    nama_genre VARCHAR(50),
    bahasa_buku VARCHAR(50),
    jenis_cover VARCHAR(50)
);

-- Tabel Penerbit
CREATE TABLE IF NOT EXISTS Penerbit (
    id_penerbit INT PRIMARY KEY,
    nama_penerbit VARCHAR(255),
    alamat_penerbit VARCHAR(255),
    no_telp_penerbit VARCHAR(15),
    email_penerbit VARCHAR(255),
    kota_penerbit VARCHAR(100),
    kodepos_penerbit INT
);

-- Tabel Buku
CREATE TABLE IF NOT EXISTS Buku (
    id_buku INT PRIMARY KEY,
    judul_buku VARCHAR(255),
    deskripsi_buku VARCHAR(255),
    status_buku VARCHAR(50),
    tahun_terbit YEAR,
    id_penulis INT,
    id_detail_buku INT,
    id_penerbit INT,
    FOREIGN KEY (id_penulis) REFERENCES Penulis(id_penulis),
    FOREIGN KEY (id_detail_buku) REFERENCES Detail_buku(id_detail_buku),
    FOREIGN KEY (id_penerbit) REFERENCES Penerbit(id_penerbit)
);


-- Tabel Peminjaman
CREATE TABLE IF NOT EXISTS Peminjaman (
    id_peminjaman INT PRIMARY KEY,
    tanggal_peminjaman DATE,
    deadline_peminjaman DATE,
    status_peminjaman VARCHAR(50),
    riwayat_peminjaman VARCHAR(255),
    id_anggota INT,
    id_staff INT,
    id_buku INT,
    FOREIGN KEY (id_anggota) REFERENCES Anggota(id_anggota),
    FOREIGN KEY (id_staff) REFERENCES Staff(id_staff),
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);
