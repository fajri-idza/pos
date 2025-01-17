-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 17, 2025 at 07:52 AM
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
('BK00001', 4, 4, '9786230032998', 'Clasmild RedMax 1 Bungkus', '9786230032998', NULL, '1 Bungkus', '2024', 1, 200000, 252000, 0, 0),
('BK00002', 3, 1, '9786230025945', 'Malboro Merah 1 Slop', '9786230025945', NULL, '1 Slop', '2024', 2, 33000, 40000, 0, 0),
('BK00003', 2, 3, '9786230042485', 'Gudang Garam Internasional 1 Bungkus', '9786230042485', NULL, '1 Bungkus', '2024', 3, 22000, 27000, 0, 0),
('BK00004', 4, 1, '9786230051517', 'Lufman Mild', '9786230051517', NULL, 'Bungkus', '2024', 2, 10000, 12000, 0, 10),
('BK00005', 1, 1, '7793704000782', 'Senar Orphe', '7793704000782', NULL, 'Bungkus', '2024', 124, 15000, 20000, 16000, 0),
('BK00006', 4, 1, '9786230079474', 'Toracino', '121321312312', 'Torcin', 'Bungkus', '2025', 100, 10000, 15000, 14000, 0);

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
('P00001', 'P0001-170305-300624', 'BK00001', 'Clasmild RedMax 1 Bungkus', 200000, 10),
('P00002', 'P0002-170305-300624', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 20),
('P00003', 'P0003-170305-300624', 'BK00002', 'Malboro Merah 1 Slop', 33000, 20),
('P00004', 'P0004-170301-090125', 'BK00004', 'Lufman Mild', 10000, 5),
('P00005', 'P0005-170301-120125', 'BK00005', 'Senar Orphe', 10000, 50),
('P00006', 'P0006-170301-120125', 'BK00005', 'Senar Orphe', 10000, 50),
('P00007', 'P0007-170301-170125', 'BK00006', 'Toracino', 10000, 100);

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
('T00001', 'T0001-170302-300624', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 27000, 0, 27000, 10, NULL),
('T00002', 'T0002-170302-300624', 'BK00002', 'Malboro Merah 1 Slop', 33000, 40000, 0, 40000, 10, NULL),
('T00003', 'T0003-170302-300624', 'BK00001', 'Clasmild RedMax 1 Bungkus', 200000, 252000, 0, 126000, 5, NULL),
('T00004', 'T0004-170302-300624', 'BK00001', 'Clasmild RedMax 1 Bungkus', 200000, 252000, 0, 75600, 3, NULL),
('T00005', 'T0004-170302-300624', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 27000, 0, 13500, 5, NULL),
('T00006', 'T0004-170302-300624', 'BK00002', 'Malboro Merah 1 Slop', 33000, 40000, 0, 20000, 5, NULL),
('T00007', 'T0005-170301-090125', 'BK00004', 'Lufman Mild', 10000, 12000, 0, 0, 1, NULL),
('T00008', 'T0006-170301-100125', 'BK00004', 'Lufman Mild', 10000, 12000, 0, 0, 2, NULL),
('T00009', 'T0007-170301-120125', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 27000, 0, 0, 2, NULL),
('T00010', 'T0008-170301-120125', 'BK00005', 'Senar Orphe', 15000, 15000, 1500, 0, 1, NULL),
('T00011', 'T0009-170301-150125', 'BK00005', 'Senar Orphe', 15000, 30000, 0, 0, 2, NULL),
('T00012', 'T0010-170301-150125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 2, NULL),
('T00013', 'T0010-170301-150125', 'BK00004', 'Lufman Mild', 10000, 10000, 1000, 0, 1, NULL),
('T00014', 'T0010-170301-150125', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 10000, 0, 0, 1, NULL),
('T00015', 'T0011-170301-150125', 'BK00005', 'Senar Orphe', 15000, 15000, 0, 0, 7, NULL),
('T00016', 'T0012-170301-150125', 'BK00005', 'Senar Orphe', 15000, 17000, 0, 0, 2, NULL),
('T00017', 'T0013-170302-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 1, NULL),
('T00018', 'T0014-170302-170125', 'BK00002', 'Malboro Merah 1 Slop', 33000, 40000, 0, 0, 1, NULL),
('T00019', 'T0015-170302-170125', 'BK00001', 'Clasmild RedMax 1 Bungkus', 200000, 252000, 0, 0, 1, 'genji'),
('T00020', 'T0016-170302-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 1, 'tes'),
('T00021', 'T0017-170302-170125', 'BK00003', 'Gudang Garam Internasional 1 Bungkus', 22000, 27000, 0, 0, 1, 'fajri'),
('T00022', 'T0018-170302-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 1, 'hoho'),
('T00023', 'T0019-170301-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 1, 'ini'),
('T00024', 'T0019-170301-170125', 'BK00002', 'Malboro Merah 1 Slop', 33000, 40000, 0, 0, 1, 'ini'),
('T00025', 'T0020-170302-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 4, 'tono'),
('T00026', 'T0021-170302-170125', 'BK00005', 'Senar Orphe', 15000, 20000, 0, 0, 1, 'mwehe'),
('T00027', 'T0022-170302-170125', 'BK00005', 'Senar Orphe', 15000, 16000, 0, 0, 3, 'rrrr');

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
('DIS0001', 'PT Gudang Garam', 'Bandung', '085854749138'),
('DIS0002', 'PT Malboro', 'Jakarta', '0265213122'),
('DIS0003', 'PT Clas Mild', 'Cilacap', '0265213123');

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
(1, 'Camel'),
(2, 'Gudang Garam'),
(3, 'Malboro'),
(4, 'Clasmild');

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

--
-- Dumping data for table `opname`
--

INSERT INTO `opname` (`idOpname`, `idBuku`, `judul`, `tanggal`, `stokSistem`, `stokNyata`, `hargaPokok`, `keterangan`) VALUES
(8, 'BK00002', 'Malboro Merah 1 Slop', '2024-06-30 12:42:37', 5, 4, 33000, '1 stok hilang');

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
('P0001-170305-300624', NULL, 'DIS0003', 'Arsya Saputra', 'PT Clas Mild', 2000000, '2024-06-30 12:35:08'),
('P0002-170305-300624', NULL, 'DIS0001', 'Arsya Saputra', 'PT Gudang Garam', 440000, '2024-06-30 12:35:30'),
('P0003-170305-300624', NULL, 'DIS0002', 'Arsya Saputra', 'PT Malboro', 660000, '2024-06-30 12:35:45'),
('P0004-170301-090125', '170301', 'DIS0003', 'admin', 'PT Clas Mild', 50000, '2025-01-09 11:03:12'),
('P0005-170301-120125', '170301', 'DIS0001', 'admin', 'PT Gudang Garam', 500000, '2025-01-12 19:59:59'),
('P0006-170301-120125', '170301', 'DIS0002', 'admin', 'PT Malboro', 500000, '2025-01-12 20:18:32'),
('P0007-170301-170125', '170301', 'DIS0003', 'admin', 'PT Clas Mild', 1000000, '2025-01-17 14:48:22');

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
('BOP001-170301-120125', NULL, NULL, NULL, 5, NULL, NULL, 'Listrik Dan Air', 50000, 'beli token', '2025-01-12 19:41:15'),
('BOP002-170301-120125', 'P0005-170301-120125', NULL, NULL, 7, NULL, NULL, 'Pembelian Barang', 500000, 'PT Gudang Garam', '2025-01-12 19:59:59'),
('BOP003-170301-120125', 'P0006-170301-120125', NULL, NULL, 7, NULL, NULL, 'Pembelian Barang', 500000, 'PT Malboro', '2025-01-12 20:18:32'),
('BOP004-170301-170125', 'P0007-170301-170125', NULL, NULL, 7, NULL, NULL, 'Pembelian Barang', 1000000, 'PT Clas Mild', '2025-01-17 14:48:22');

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
('T0001-170302-300624', '170302', 'Erna Ratnasari', NULL, 297000, 27000, '2024-06-30 12:36:11', 1),
('T0002-170302-300624', '170302', 'Erna Ratnasari', NULL, 440000, 40000, '2024-06-30 12:36:22', 1),
('T0003-170302-300624', '170302', 'Erna Ratnasari', NULL, 1386000, 126000, '2024-06-30 12:36:32', 1),
('T0004-170302-300624', '170302', 'Erna Ratnasari', NULL, 1200100, 109100, '2024-06-30 12:37:24', 1),
('T0005-170301-090125', '170301', 'admin', NULL, 12000, 0, '2025-01-09 11:05:04', 0),
('T0006-170301-100125', '170301', 'admin', NULL, 24000, 0, '2025-01-10 13:36:01', 1),
('T0007-170301-120125', '170301', 'admin', NULL, 54000, 0, '2025-01-12 19:40:07', 0),
('T0008-170301-120125', '170301', 'admin', NULL, 13500, 0, '2025-01-12 20:22:25', 1),
('T0009-170301-150125', '170301', 'admin', NULL, 60000, 0, '2025-01-15 11:34:42', 1),
('T0010-170301-150125', '170301', 'admin', NULL, 59000, 0, '2025-01-15 11:56:02', 1),
('T0011-170301-150125', '170301', 'admin', NULL, 105000, 0, '2025-01-15 12:03:39', 1),
('T0012-170301-150125', '170301', 'admin', NULL, 34000, 0, '2025-01-15 12:04:37', 1),
('T0013-170302-170125', '170302', 'Kasir', NULL, 20000, 0, '2025-01-17 13:26:01', 1),
('T0014-170302-170125', '170302', 'Kasir', NULL, 40000, 0, '2025-01-17 13:47:39', 1),
('T0015-170302-170125', '170302', 'Kasir', NULL, 252000, 0, '2025-01-17 13:52:31', 1),
('T0016-170302-170125', '170302', 'Kasir', NULL, 20000, 0, '2025-01-17 13:53:34', 1),
('T0017-170302-170125', '170302', 'Kasir', NULL, 27000, 0, '2025-01-17 14:00:46', 1),
('T0018-170302-170125', '170302', 'Kasir', NULL, 20000, 0, '2025-01-17 14:05:09', 1),
('T0019-170301-170125', '170301', 'admin', NULL, 60000, 0, '2025-01-17 14:11:56', 1),
('T0020-170302-170125', '170302', 'Kasir', NULL, 80000, 0, '2025-01-17 14:27:35', 1),
('T0021-170302-170125', '170302', 'Kasir', 'mwehe', 20000, 0, '2025-01-17 14:29:01', 1),
('T0022-170302-170125', '170302', 'Kasir', 'rrrr', 48000, 0, '2025-01-17 14:45:49', 1);

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
('PPN0001-170302-300624', 'T0001-170302-300624', '170302', 'PPN Dikeluarkan', 27000, 'T0001', '2024-06-30 12:36:11'),
('PPN0002-170302-300624', 'T0002-170302-300624', '170302', 'PPN Dikeluarkan', 40000, 'T0002', '2024-06-30 12:36:22'),
('PPN0003-170302-300624', 'T0003-170302-300624', '170302', 'PPN Dikeluarkan', 126000, 'T0003', '2024-06-30 12:36:32'),
('PPN0004-170302-300624', 'T0004-170302-300624', '170302', 'PPN Dikeluarkan', 109100, 'T0004', '2024-06-30 12:37:24'),
('PPN0005-170301-100125', 'T0006-170301-100125', '170301', 'PPN Dikeluarkan', 0, 'T0006', '2025-01-10 13:36:01'),
('PPN0006-170301-120125', 'T0008-170301-120125', '170301', 'PPN Dikeluarkan', 0, 'T0008', '2025-01-12 20:22:25'),
('PPN0007-170301-150125', 'T0009-170301-150125', '170301', 'PPN Dikeluarkan', 0, 'T0009', '2025-01-15 11:34:42'),
('PPN0008-170301-150125', 'T0010-170301-150125', '170301', 'PPN Dikeluarkan', 0, 'T0010', '2025-01-15 11:56:02'),
('PPN0009-170301-150125', 'T0011-170301-150125', '170301', 'PPN Dikeluarkan', 0, 'T0011', '2025-01-15 12:03:39'),
('PPN0010-170301-150125', 'T0012-170301-150125', '170301', 'PPN Dikeluarkan', 0, 'T0012', '2025-01-15 12:04:37'),
('PPN0011-170302-170125', 'T0013-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0013', '2025-01-17 13:26:02'),
('PPN0012-170302-170125', 'T0014-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0014', '2025-01-17 13:47:39'),
('PPN0013-170302-170125', 'T0015-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0015', '2025-01-17 13:52:31'),
('PPN0014-170302-170125', 'T0016-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0016', '2025-01-17 13:53:34'),
('PPN0015-170302-170125', 'T0017-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0017', '2025-01-17 14:00:46'),
('PPN0016-170302-170125', 'T0018-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0018', '2025-01-17 14:05:09'),
('PPN0017-170301-170125', 'T0019-170301-170125', '170301', 'PPN Dikeluarkan', 0, 'T0019', '2025-01-17 14:11:56'),
('PPN0018-170302-170125', 'T0020-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0020', '2025-01-17 14:27:35'),
('PPN0019-170302-170125', 'T0021-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0021', '2025-01-17 14:29:01'),
('PPN0020-170302-170125', 'T0022-170302-170125', '170302', 'PPN Dikeluarkan', 0, 'T0022', '2025-01-17 14:45:49');

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
('170302', 'Kasir', 'Bengkulu', '0821213977632', 'kasir', 'c7911af3adbd12a035b289556d96470a', '2'),
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
  MODIFY `idKategori` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
