-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 24, 2025 at 10:12 AM
-- Server version: 8.0.30
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_toko`
--

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `idBuku` varchar(10) NOT NULL,
  `idKategori` int DEFAULT NULL,
  `idRak` int DEFAULT NULL,
  `barcode` varchar(30) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `noisbn` varchar(50) DEFAULT NULL,
  `penulis` varchar(50) DEFAULT NULL,
  `penerbit` varchar(50) NOT NULL,
  `tahun` varchar(4) NOT NULL,
  `stock` int UNSIGNED NOT NULL,
  `hargaPokok` int NOT NULL,
  `hargaJual` int NOT NULL,
  `hargaReseller` int NOT NULL DEFAULT '0',
  `disc` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`idBuku`, `idKategori`, `idRak`, `barcode`, `judul`, `noisbn`, `penulis`, `penerbit`, `tahun`, `stock`, `hargaPokok`, `hargaJual`, `hargaReseller`, `disc`) VALUES
('BK00001', 8, 1, '9786230048197', 'Gitar Yahama', '9786230048197', NULL, 'Unit', '2024', 1, 800000, 1000000, 900000, 0),
('BK00002', 9, 2, '9786230010903', 'Kajon Yamaha', '9786230010903', NULL, 'Unit', '2024', 0, 300000, 500000, 400000, 0),
('BK00003', 10, 3, '9786230072048', 'Senar Orphee', '9786230072048', NULL, 'Bungkus', '2024', 0, 30000, 50000, 40000, 0),
('BK00004', 11, 4, '9786230080784', 'Ampli Yamaha', '9786230080784', NULL, 'Unit', '2024', 0, 2300000, 2500000, 2400000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `detail_pembelian`
--

CREATE TABLE `detail_pembelian` (
  `idDetailPembelian` varchar(6) NOT NULL,
  `idPembelian` varchar(20) NOT NULL,
  `idBuku` varchar(10) DEFAULT NULL,
  `judul` varchar(100) NOT NULL,
  `hargaPokok` int NOT NULL,
  `jumlah` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_pembelian`
--

INSERT INTO `detail_pembelian` (`idDetailPembelian`, `idPembelian`, `idBuku`, `judul`, `hargaPokok`, `jumlah`) VALUES
('P00001', 'P0001-170301-170125', 'BK00004', 'Ampli Yamaha', 2300000, 2),
('P00002', 'P0001-170301-170125', 'BK00001', 'Gitar Yahama', 800000, 1),
('P00003', 'P0002-170301-170125', 'BK00002', 'Kajon Yamaha', 300000, 2);

--
-- Triggers `detail_pembelian`
--
DELIMITER $$
CREATE TRIGGER `update stock` BEFORE INSERT ON `detail_pembelian` FOR EACH ROW UPDATE buku a set a.stock = a.stock + new.jumlah where a.idBuku = new.idBuku
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_penjualan`
--

CREATE TABLE `detail_penjualan` (
  `idDetailPenjualan` varchar(6) NOT NULL,
  `idPenjualan` varchar(20) NOT NULL,
  `idBuku` varchar(10) DEFAULT NULL,
  `judul` varchar(100) NOT NULL,
  `hargaPokok` int NOT NULL,
  `hargaJual` int NOT NULL,
  `disc` float NOT NULL,
  `ppn` int NOT NULL,
  `jumlah` int NOT NULL,
  `pembeli` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_penjualan`
--

INSERT INTO `detail_penjualan` (`idDetailPenjualan`, `idPenjualan`, `idBuku`, `judul`, `hargaPokok`, `hargaJual`, `disc`, `ppn`, `jumlah`, `pembeli`) VALUES
('T00001', 'T0001-170301-170125', 'BK00004', 'Ampli Yamaha', 2300000, 2500000, 0, 0, 1, NULL),
('T00002', 'T0002-170301-170125', 'BK00002', 'Kajon Yamaha', 300000, 400000, 0, 0, 1, 'Joni'),
('T00003', 'T0002-170301-170125', 'BK00004', 'Ampli Yamaha', 2300000, 2400000, 0, 0, 1, 'Joni'),
('T00004', 'T0003-170301-170125', 'BK00004', 'Ampli Yamaha', 2300000, 2300000, 0, 0, 1, NULL),
('T00005', 'T0004-170302-240125', 'BK00002', 'Kajon Yamaha', 300000, 500000, 0, 0, 1, NULL);

--
-- Triggers `detail_penjualan`
--
DELIMITER $$
CREATE TRIGGER `update_stok_buku` BEFORE INSERT ON `detail_penjualan` FOR EACH ROW UPDATE buku a set a.stock = a.stock - new.jumlah where idBuku = new.idBuku
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `distributor`
--

CREATE TABLE `distributor` (
  `idDist` varchar(10) NOT NULL,
  `namaDist` varchar(50) NOT NULL,
  `alamat` varchar(250) NOT NULL,
  `telepon` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `distributor`
--

INSERT INTO `distributor` (`idDist`, `namaDist`, `alamat`, `telepon`) VALUES
('DIS0001', 'Yamaha 46', '123', '123');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `idKategori` int NOT NULL,
  `nama_kategori` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`idKategori`, `nama_kategori`) VALUES
(8, 'Gitar'),
(9, 'Kajon'),
(10, 'Senar'),
(11, 'Ampli');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_pengeluaran`
--

CREATE TABLE `kategori_pengeluaran` (
  `idKategoriPengeluaran` int NOT NULL,
  `nama` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategori_pengeluaran`
--

INSERT INTO `kategori_pengeluaran` (`idKategoriPengeluaran`, `nama`) VALUES
(1, 'Gaji Karyawan'),
(3, 'Bayar Pajak'),
(4, 'StokOpName'),
(5, 'Listrik Dan Air'),
(7, 'Pembelian Barang');

-- --------------------------------------------------------

--
-- Table structure for table `opname`
--

CREATE TABLE `opname` (
  `idOpname` int NOT NULL,
  `idBuku` varchar(10) DEFAULT NULL,
  `judul` varchar(100) NOT NULL,
  `tanggal` datetime NOT NULL,
  `stokSistem` int NOT NULL,
  `stokNyata` int NOT NULL,
  `hargaPokok` int NOT NULL,
  `keterangan` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pembelian`
--

CREATE TABLE `pembelian` (
  `idPembelian` varchar(20) NOT NULL,
  `idUser` varchar(10) DEFAULT NULL,
  `idDist` varchar(10) DEFAULT NULL,
  `namaUser` varchar(50) NOT NULL,
  `namaDist` varchar(50) NOT NULL,
  `total` int NOT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pembelian`
--

INSERT INTO `pembelian` (`idPembelian`, `idUser`, `idDist`, `namaUser`, `namaDist`, `total`, `tanggal`) VALUES
('P0001-170301-170125', '170301', 'DIS0001', 'admin', 'Yamaha 46', 5400000, '2025-01-17 20:37:29'),
('P0002-170301-170125', '170301', 'DIS0001', 'admin', 'Yamaha 46', 600000, '2025-01-17 20:39:10');

-- --------------------------------------------------------

--
-- Table structure for table `pengaturan`
--

CREATE TABLE `pengaturan` (
  `idPengaturan` int NOT NULL,
  `idUser` varchar(10) DEFAULT NULL,
  `nama_toko` varchar(20) NOT NULL,
  `alamat_toko` varchar(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `telepon_toko` varchar(15) NOT NULL,
  `logo` varchar(50) NOT NULL,
  `pakaiLogo` tinyint(1) DEFAULT '1',
  `ppn` double NOT NULL,
  `min_stok` int NOT NULL DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pengaturan`
--

INSERT INTO `pengaturan` (`idPengaturan`, `idUser`, `nama_toko`, `alamat_toko`, `telepon_toko`, `logo`, `pakaiLogo`, `ppn`, `min_stok`) VALUES
(1, '170301', 'Bengkulu Guitar', 'JL Kalimantan Kampung Bali, Sungai Serut, Kampung Kelawi, kota Bengkulu, Bengkulu', '085896173343', '1736401475.png', 1, 0, 5);

-- --------------------------------------------------------

--
-- Table structure for table `pengeluaran`
--

CREATE TABLE `pengeluaran` (
  `idPengeluaran` varchar(20) NOT NULL,
  `idPembelian` varchar(20) DEFAULT NULL,
  `idOpname` int DEFAULT NULL,
  `idPajak` varchar(21) DEFAULT NULL,
  `idKategoriPengeluaran` int DEFAULT NULL,
  `idUser` varchar(10) DEFAULT NULL,
  `namaUser` varchar(50) DEFAULT NULL,
  `namaKategori` varchar(50) NOT NULL,
  `pengeluaran` int NOT NULL,
  `keterangan` varchar(30) DEFAULT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pengeluaran`
--

INSERT INTO `pengeluaran` (`idPengeluaran`, `idPembelian`, `idOpname`, `idPajak`, `idKategoriPengeluaran`, `idUser`, `namaUser`, `namaKategori`, `pengeluaran`, `keterangan`, `tanggal`) VALUES
('BOP001-170301-170125', 'P0001-170301-170125', NULL, NULL, 7, NULL, NULL, 'Pembelian Barang', 5400000, 'Yamaha 46', '2025-01-17 20:37:29'),
('BOP002-170301-170125', 'P0002-170301-170125', NULL, NULL, 7, NULL, NULL, 'Pembelian Barang', 600000, 'Yamaha 46', '2025-01-17 20:39:10');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `idPenjualan` varchar(20) NOT NULL,
  `idUser` varchar(10) DEFAULT NULL,
  `namaUser` varchar(50) NOT NULL,
  `namaPembeli` varchar(255) DEFAULT NULL,
  `total` int NOT NULL,
  `ppn` int NOT NULL,
  `tanggal` datetime NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`idPenjualan`, `idUser`, `namaUser`, `namaPembeli`, `total`, `ppn`, `tanggal`, `status`) VALUES
('T0001-170301-170125', '170301', 'admin', NULL, 2500000, 0, '2025-01-17 20:40:45', 1),
('T0002-170301-170125', '170301', 'admin', 'Joni', 2800000, 0, '2025-01-17 20:41:17', 1),
('T0003-170301-170125', '170301', 'admin', NULL, 2300000, 0, '2025-01-17 20:48:48', 1),
('T0004-170302-240125', '170302', 'Tono', NULL, 500000, 0, '2025-01-24 16:26:56', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ppn`
--

CREATE TABLE `ppn` (
  `idPajak` varchar(21) NOT NULL,
  `idPenjualan` varchar(20) DEFAULT NULL,
  `idUser` varchar(10) DEFAULT NULL,
  `jenis` varchar(100) NOT NULL,
  `nominal` int NOT NULL,
  `keterangan` varchar(100) DEFAULT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ppn`
--

INSERT INTO `ppn` (`idPajak`, `idPenjualan`, `idUser`, `jenis`, `nominal`, `keterangan`, `tanggal`) VALUES
('PPN0001-170301-170125', 'T0001-170301-170125', '170301', 'PPN Dikeluarkan', 0, 'T0001', '2025-01-17 20:40:45'),
('PPN0002-170301-170125', 'T0002-170301-170125', '170301', 'PPN Dikeluarkan', 0, 'T0002', '2025-01-17 20:41:17'),
('PPN0003-170301-170125', 'T0003-170301-170125', '170301', 'PPN Dikeluarkan', 0, 'T0003', '2025-01-17 20:48:48'),
('PPN0004-170302-240125', 'T0004-170302-240125', '170302', 'PPN Dikeluarkan', 0, 'T0004', '2025-01-24 16:26:56');

-- --------------------------------------------------------

--
-- Table structure for table `rak`
--

CREATE TABLE `rak` (
  `idRak` int NOT NULL,
  `nama_rak` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rak`
--

INSERT INTO `rak` (`idRak`, `nama_rak`) VALUES
(1, '1'),
(2, '2'),
(3, '3'),
(4, '4');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `idUser` varchar(10) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `alamat` varchar(250) NOT NULL,
  `telepon` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(64) NOT NULL,
  `hakAkses` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`idUser`, `nama`, `alamat`, `telepon`, `username`, `password`, `hakAkses`) VALUES
('170301', 'admin', 'Bengkulu', '082121397663', 'admin', '21232f297a57a5a743894a0e4a801fc3', '1'),
('170302', 'Tono', 'Bengkulu', '0821213977632', 'kasir', 'c7911af3adbd12a035b289556d96470a', '2'),
('170304', 'gudang', 'Bengkulu', '082181412', 'gudang', '202446dd1d6028084426867365b0c7a1', '3');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`idBuku`),
  ADD KEY `fk_rakbuku` (`idRak`),
  ADD KEY `fk_kategoribuku` (`idKategori`);

--
-- Indexes for table `detail_pembelian`
--
ALTER TABLE `detail_pembelian`
  ADD PRIMARY KEY (`idDetailPembelian`),
  ADD KEY `fk_detailpasok` (`idPembelian`),
  ADD KEY `fk_detailpasokbuku` (`idBuku`);

--
-- Indexes for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD PRIMARY KEY (`idDetailPenjualan`),
  ADD KEY `fk_transaksipenjualan` (`idPenjualan`),
  ADD KEY `fk_transaksibuku` (`idBuku`);

--
-- Indexes for table `distributor`
--
ALTER TABLE `distributor`
  ADD PRIMARY KEY (`idDist`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`idKategori`);

--
-- Indexes for table `kategori_pengeluaran`
--
ALTER TABLE `kategori_pengeluaran`
  ADD PRIMARY KEY (`idKategoriPengeluaran`);

--
-- Indexes for table `opname`
--
ALTER TABLE `opname`
  ADD PRIMARY KEY (`idOpname`),
  ADD KEY `fk_opname_buku` (`idBuku`);

--
-- Indexes for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD PRIMARY KEY (`idPembelian`),
  ADD KEY `fk_pasok_user` (`idUser`),
  ADD KEY `fk_pasok_dist` (`idDist`);

--
-- Indexes for table `pengaturan`
--
ALTER TABLE `pengaturan`
  ADD PRIMARY KEY (`idPengaturan`),
  ADD KEY `fk_pengaturan_user` (`idUser`);

--
-- Indexes for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD PRIMARY KEY (`idPengeluaran`),
  ADD KEY `fk_pengeluaran_user` (`idUser`),
  ADD KEY `fk_kategori_pengeluaran` (`idKategoriPengeluaran`),
  ADD KEY `fk_pasok_pengeluaran` (`idPembelian`),
  ADD KEY `fk_pengeluaran_opname` (`idOpname`),
  ADD KEY `fk_pengeluaran_ppn` (`idPajak`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`idPenjualan`),
  ADD KEY `fk_penjualan_kasir` (`idUser`);

--
-- Indexes for table `ppn`
--
ALTER TABLE `ppn`
  ADD PRIMARY KEY (`idPajak`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `idPenjualan` (`idPenjualan`);

--
-- Indexes for table `rak`
--
ALTER TABLE `rak`
  ADD PRIMARY KEY (`idRak`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `idKategori` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `kategori_pengeluaran`
--
ALTER TABLE `kategori_pengeluaran`
  MODIFY `idKategoriPengeluaran` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `opname`
--
ALTER TABLE `opname`
  MODIFY `idOpname` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pengaturan`
--
ALTER TABLE `pengaturan`
  MODIFY `idPengaturan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `rak`
--
ALTER TABLE `rak`
  MODIFY `idRak` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `buku`
--
ALTER TABLE `buku`
  ADD CONSTRAINT `fk_kategoribuku` FOREIGN KEY (`idKategori`) REFERENCES `kategori` (`idKategori`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rakbuku` FOREIGN KEY (`idRak`) REFERENCES `rak` (`idRak`) ON DELETE SET NULL;

--
-- Constraints for table `detail_pembelian`
--
ALTER TABLE `detail_pembelian`
  ADD CONSTRAINT `fk_detailpasok` FOREIGN KEY (`idPembelian`) REFERENCES `pembelian` (`idPembelian`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detailpasokbuku` FOREIGN KEY (`idBuku`) REFERENCES `buku` (`idBuku`) ON DELETE SET NULL;

--
-- Constraints for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD CONSTRAINT `fk_transaksibuku` FOREIGN KEY (`idBuku`) REFERENCES `buku` (`idBuku`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_transaksipenjualan` FOREIGN KEY (`idPenjualan`) REFERENCES `penjualan` (`idPenjualan`) ON DELETE CASCADE;

--
-- Constraints for table `opname`
--
ALTER TABLE `opname`
  ADD CONSTRAINT `fk_opname_buku` FOREIGN KEY (`idBuku`) REFERENCES `buku` (`idBuku`) ON DELETE SET NULL;

--
-- Constraints for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD CONSTRAINT `fk_pasok_dist` FOREIGN KEY (`idDist`) REFERENCES `distributor` (`idDist`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pasok_user` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE SET NULL;

--
-- Constraints for table `pengaturan`
--
ALTER TABLE `pengaturan`
  ADD CONSTRAINT `fk_pengaturan_user` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE SET NULL;

--
-- Constraints for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD CONSTRAINT `fk_kategori_pengeluaran` FOREIGN KEY (`idKategoriPengeluaran`) REFERENCES `kategori_pengeluaran` (`idKategoriPengeluaran`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pasok_pengeluaran` FOREIGN KEY (`idPembelian`) REFERENCES `pembelian` (`idPembelian`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pengeluaran_opname` FOREIGN KEY (`idOpname`) REFERENCES `opname` (`idOpname`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pengeluaran_ppn` FOREIGN KEY (`idPajak`) REFERENCES `ppn` (`idPajak`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pengeluaran_user` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE SET NULL;

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `fk_penjualan_kasir` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE SET NULL;

--
-- Constraints for table `ppn`
--
ALTER TABLE `ppn`
  ADD CONSTRAINT `ppn_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`) ON DELETE SET NULL,
  ADD CONSTRAINT `ppn_ibfk_2` FOREIGN KEY (`idPenjualan`) REFERENCES `penjualan` (`idPenjualan`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
